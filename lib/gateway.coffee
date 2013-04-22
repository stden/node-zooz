# https://app.zooz.com/portal/pages/files/ZooZ_Extended_Server_API.pdf

querystring = require 'querystring'
validator   = require 'validator'
request     = require 'request'
check       = require 'check-types'

getConfig = require '../config'

TransactionMapper = require '../mapper/TransactionMapper'

class ZoozGateway

  @getAllowedServerIP = (environment=process.env.NODE_ENV) ->
    if environment in ['production', 'staging']
      return [
        '195.28.181.179'
        '91.228.127.99' 
        '91.228.127.100' 
        '195.28.181.191'
        '195.28.181.192'
      ]
    else return ['127.0.0.1']


  constructor: (apiKeys, httpClient = request, transactionMapper = TransactionMapper) ->
    throw new Error 'Invalid developerId' unless apiKeys?.extendedServer?.developerId? and typeof apiKeys.extendedServer.developerId is 'string'
    throw new Error 'Invalid serverAPIKey' unless apiKeys?.extendedServer?.serverAPIKey? and typeof apiKeys.extendedServer.serverAPIKey is 'string'    
    throw new Error 'Invalid ZooZUniqueID' unless apiKeys?.web?.ZooZUniqueID? and typeof apiKeys.web.ZooZUniqueID is 'string'
    throw new Error 'Invalid ZooZAppKey' unless apiKeys?.web?.ZooZAppKey? and typeof apiKeys.web.ZooZAppKey is 'string'

    throw new Error 'Invalid http client' unless httpClient instanceof Function
    throw new Error 'Invalid transaction mapper' unless transactionMapper instanceof Function
    @apiKeys = apiKeys
    @request = httpClient
    @transactionMapper = transactionMapper


  buildExtendedServerRequest: (body) ->
    throw new Error 'Invalid body' unless body? and check.isObject body
    throw new Error 'Invalid body' if check.isEmptyObject body

    url = 'https://sandbox.zooz.co/mobile/ExtendedServerAPI'
    url = 'https://app.zooz.com/mobile/ExtendedServerAPI' if process.env.NODE_ENV in ['production']
    
    return {
      url: getConfig().extendedServer.url
      method: getConfig().method
      encoding: getConfig().encoding
      timeout: getConfig().timeout
      strictSSL: true
      headers:
        ZooZDeveloperId: @apiKeys.extendedServer.developerId
        ZooZServerAPIKey: @apiKeys.extendedServer.serverAPIKey
        "Content-type": 'application/x-www-form-urlencoded'
        Accetp: 'application/json'
      body: querystring.stringify body
    }


  buildSecuredWebServletRequest: (body) ->
    throw new Error 'Invalid body' unless body? and check.isObject body
    throw new Error 'Invalid body' if check.isEmptyObject body

    url = 'https://sandbox.zooz.co/mobile/SecuredWebServlet'
    url = 'https://app.zooz.com/mobile/SecuredWebServlet' if process.env.NODE_ENV in ['production']

    return {
      url: "#{getConfig().web.url}?#{querystring.stringify(body)}"
      method: getConfig().method
      encoding: getConfig().encoding
      timeout: getConfig().timeout
      strictSSL: true
      headers:
        ZooZUniqueID: @apiKeys.web.ZooZUniqueID
        ZooZAppKey: @apiKeys.web.ZooZAppKey
        "Content-type": 'application/x-www-form-urlencoded'
        ZooZResponseType: 'NVP'
    }


  getTransactionById: (transactionId, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'

    return @requestBy 'transactionId', transactionId, callback


  getTransactionByEmail: (email, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function
    return callback new Error('Invalid email'), null unless typeof email is 'string' and email.length > 0
    
    try validator.check(email,'Invalid email').isEmail()
    catch error then return callback error, null

    return @requestBy 'email', email, callback


  requestBy: (byMethod, value, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function
    return callback new Error('Invalid by method'), null unless byMethod in ['email', 'transactionId']
    return callback new Error('Invalid value'), null unless typeof value is 'string'

    body = 
      cmd: 'getTransactionDetails'
      ver: getConfig().version

    if byMethod is 'email' then body.email = value else body.transactionID = value

    console.log @buildExtendedServerRequest(body)

    return @request @buildExtendedServerRequest(body), (err, response, body) =>
      return callback err, null if err?

      body = JSON.parse body
      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?

      console.log 'ZOOZ body', body
      
      try transaction = @transactionMapper.unmarshall body.ResponseObject
      catch error then return callback error, null

      return callback null, transaction


  commitTransaction: (transactionId, amount, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'
    return callback new Error('Invalid amount'), null if amount? and not check.isPositiveNumber amount

    body =
      cmd: 'commitTransaction'
      ver: getConfig().version
      transactionID: transactionId
      amount: amount

    console.log @buildExtendedServerRequest(body)

    return @request @buildExtendedServerRequest(body), (err, response, body) ->
      return callback err, null if err?
      
      body = JSON.parse body

      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?

      return callback null, body.ResponseObject


  rollbackTransaction: (transactionId, amount, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'
    return callback new Error('Invalid amount'), null unless check.isPositiveNumber amount

    body =
      cmd: 'refundTransaction'
      ver: getConfig().version
      transactionID: transactionId
      amount: amount

    console.log @buildExtendedServerRequest(body)

    return @request @buildExtendedServerRequest(body), (err, response, body) ->
      return callback err, null if err?
      
      body = JSON.parse body
      
      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?

      return callback null, body.ResponseObject


  openTransaction: (amount, currencyCode='GBP', userId, reference, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function

    options = @buildSecuredWebServletRequest {
      cmd: 'openTrx'
      ver: getConfig().version
      amount: amount
      currencyCode: currencyCode
      "user.idNumber": userId
      "invoice.additionalDetails": "#{reference}"
    }

    console.log options

    @request options, (err, response, body) =>
      return callback err, null if err?
      return callback new Error('missing Zooz response'), null unless body?

      body = querystring.parse body

      return callback new Error('missing token'), null unless body.token?
      return callback new Error(body.errorMessage), null if body.errorMessage?

      return callback null, body.token


  verifyTransaction: (transactionId, callback) ->
    throw new Error 'Invalid callback' unless callback? and callback instanceof Function

    options = @buildSecuredWebServletRequest {
      cmd: 'verifyTrx'
      transactionID: transactionId
    }

    console.log options

    @request options, (err, response, body) =>
      return callback err, null if err?
      return callback new Error('missing Zooz response'), null unless body?

      body = querystring.parse body
      console.log body

      return callback new Error(body.errorMessage), null if body.errorMessage?

      return callback null, body.token


module.exports = ZoozGateway