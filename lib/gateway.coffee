# https://app.zooz.com/portal/pages/files/ZooZ_Extended_Server_API.pdf

querystring = require 'querystring'
validator   = require 'validator'
request     = require 'request'
check       = require 'check-types'
_           = require 'lodash'

config = require '../config'

TransactionMapper = require '../mapper/TransactionMapper'

class ZoozGateway

  @getAllowedServerIP = () ->
    return config.zoozIpAddrs


  constructor: (apiKeys, httpClient = request, transactionMapper = TransactionMapper, opts = {}) ->
    throw new Error 'Invalid developerId' unless apiKeys?.extendedServer?.developerId? and typeof apiKeys.extendedServer.developerId is 'string'
    throw new Error 'Invalid serverAPIKey' unless apiKeys?.extendedServer?.serverAPIKey? and typeof apiKeys.extendedServer.serverAPIKey is 'string'
    throw new Error 'Invalid ZooZUniqueID' unless apiKeys?.web?.ZooZUniqueID? and typeof apiKeys.web.ZooZUniqueID is 'string'
    throw new Error 'Invalid ZooZAppKey' unless apiKeys?.web?.ZooZAppKey? and typeof apiKeys.web.ZooZAppKey is 'string'

    throw new Error 'Invalid http client' unless httpClient instanceof Function
    throw new Error 'Invalid transaction mapper' unless transactionMapper instanceof Function
    @apiKeys = apiKeys
    @request = httpClient
    @transactionMapper = transactionMapper

    @sandboxMode = if opts.sandboxMode? then opts.sandboxMode else false
    @logger = if opts.logger? then opts.logger else ()->
    @config = if opts.config? then _.assign(config, opts.config) else config
    @opts = opts

  buildExtendServerUrl: () ->
    if @opts.extendedServerUrl? then return @opts.extendedServerUrl
    if @sandboxMode then @config.extendedServer.url.sandbox else @config.extendedServer.url.production

  buildWebUrl: () ->
    if @opts.webUrl? then return @opts.webUrl
    if @sandboxMode then @config.web.url.sandbox else @config.web.url.production

  buildExtendedServerRequest: (body) ->
    throw new Error 'Invalid body' unless body? and check.isObject body
    throw new Error 'Invalid body' if check.isEmptyObject body

    return {
      url: @buildExtendServerUrl()
      method: @config.request.method
      encoding: @config.request.encoding
      timeout: @config.request.timeout
      strictSSL: true
      headers:
        ZooZDeveloperId: @apiKeys.extendedServer.developerId
        ZooZServerAPIKey: @apiKeys.extendedServer.serverAPIKey
        "Content-type": 'application/x-www-form-urlencoded'
        Accept: 'application/json'
      body: querystring.stringify body
    }


  buildSecuredWebServletRequest: (body) ->
    throw new Error 'Invalid body' unless body? and check.isObject body
    throw new Error 'Invalid body' if check.isEmptyObject body

    url = @buildWebUrl()

    return {
      url: "#{url}?#{querystring.stringify(body)}"
      method: @config.request.method
      encoding: @config.request.encoding
      timeout: @config.request.timeout
      strictSSL: true
      headers:
        ZooZUniqueID: @apiKeys.web.ZooZUniqueID
        ZooZAppKey: @apiKeys.web.ZooZAppKey
        "Content-type": 'application/x-www-form-urlencoded'
        ZooZResponseType: 'NVP'
    }


  getTransactionById: (transactionId, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'

    return @requestBy 'transactionId', transactionId, callback


  getTransactionByEmail: (email, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function
    return callback new Error('Invalid email'), null unless typeof email is 'string' and email.length > 0

    try validator.check(email,'Invalid email').isEmail()
    catch error then return callback error, null

    return @requestBy 'email', email, callback


  requestBy: (byMethod, value, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function
    return callback new Error('Invalid by method'), null unless byMethod in ['email', 'transactionId']
    return callback new Error('Invalid value'), null unless typeof value is 'string'

    body =
      cmd: 'getTransactionDetails'
      ver: @config.version

    if byMethod is 'email' then body.email = value else body.transactionID = value

    @logger @buildExtendedServerRequest(body)

    return @request @buildExtendedServerRequest(body), (err, response, body) =>
      return callback err, null if err?

      try
        body = JSON.parse body
      catch parseError
        return callback new Error("error parsing Zooz response JSON :: [#{parseError}]")

      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?

      @logger {'ZOOZ-body', body}

      try transaction = @transactionMapper.unmarshall body.ResponseObject
      catch error then return callback error, null

      return callback null, transaction


  commitTransaction: (transactionId, amount, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'
    return callback new Error('Invalid amount'), null if amount? and not check.isPositiveNumber amount

    body =
      cmd: 'commitTransaction'
      ver: @config.version
      transactionID: transactionId
      amount: amount

    builtBody = @buildExtendedServerRequest(body)
    @logger {builtBody: builtBody}

    return @request builtBody, (err, response, body) =>
      return callback err, null if err?

      try
        body = JSON.parse body
      catch parseError
        return callback new Error("error parsing Zooz response JSON :: [#{parseError}]")

      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?
      return callback null, body.ResponseObject


  rollbackTransaction: (transactionId, amount, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function
    return callback new Error('Invalid transaction id'), null unless typeof transactionId is 'string'
    return callback new Error('Invalid amount'), null unless check.isPositiveNumber amount

    body =
      cmd: 'refundTransaction'
      ver: @config.version
      transactionID: transactionId
      amount: amount

    builtBody = @buildExtendedServerRequest(body)
    @logger {builtBody: builtBody}

    return @request builtBody, (err, response, body) =>
      return callback err, null if err?

      try
        body = JSON.parse body
      catch parseError
        return callback new Error("error parsing Zooz response JSON :: [#{parseError}]")

      return callback new Error('missing Zooz response'), null unless body?.ResponseObject?
      return callback new Error(body.ResponseObject.errorMessage), null if body.ResponseObject?.errorMessage?
      return callback null, body.ResponseObject


  openTransaction: (amount, currencyCode='GBP', userId, reference, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function

    options = @buildSecuredWebServletRequest {
      cmd: 'openTrx'
      ver: @config.version
      amount: amount
      currencyCode: currencyCode
      "user.idNumber": userId
      "invoice.additionalDetails": "#{reference}"
    }

    @logger {options: options}

    @request options, (err, response, body) =>
      return callback err, null if err?
      return callback new Error('missing Zooz response'), null unless body?

      body = querystring.parse body

      return callback new Error('missing token'), null unless body.token?
      return callback new Error(body.errorMessage), null if body.errorMessage?

      return callback null, body.token


  verifyTransaction: (transactionId, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function

    options = @buildSecuredWebServletRequest {
      cmd: 'verifyTrx'
      transactionID: transactionId
    }

    @logger {options: options}

    @request options, (err, response, body) =>
      return callback err, null if err?
      return callback new Error('missing Zooz response'), null unless body?

      body = querystring.parse body
      @logger {body: body}

      return callback new Error(body.errorMessage), null if body.errorMessage?

      return callback null, body.token


  voidTransaction: (transaction, callback) ->
    throw new Error 'Invalid callback' unless callback instanceof Function

    return callback null, {
      transactionID: transaction.transactionID
      status: 'voided'
    }


module.exports = ZoozGateway
