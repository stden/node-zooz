check = require 'check-types'

class Transaction

  constructor: (transactionId) ->

    @setTransactionId transactionId if transactionId?


  setTransactionId: (transactionId) ->
    throw new Error 'Invalid transaction id' unless typeof transactionId is 'string'
    @transactionID = transactionId


  setAppName: (name) ->
    throw new Error 'Invalid name' unless typeof name is 'string'
    @appName = name


  setIsSandbox: (isSandbox) ->
    throw new Error 'Invalid isSandbox' unless typeof isSandbox is 'boolean'
    @isSandbox = isSandbox


  setTransactionStatus: (status) ->
    throw new Error 'Invalid transaction status' unless typeof status is 'string'

    #what to do about you?
    #console.log 'Unexpected transaction status' unless status in ['Pending', 'TPCPending', 'AuthorizationProcess', 'Succeed']

    @transactionStatus = status


  setFoundSourceType: (source) ->
    throw new Error 'Invalid source' unless typeof source is 'string'
    @fundSourceType = source


  setLastFourDigits: (lastFourDigits) ->
    throw new Error 'Invalid last four digits' unless /^[0-9]{4}$/i.test lastFourDigits
    @lastFourDigits = lastFourDigits


  setOriginalAmount: (amount) ->
    throw new Error 'Invalid original amount' unless check.isNumber amount
    @amount = amount


  setPaidAmount: (amount) ->
    throw new Error 'Invalid paid amount' unless check.isNumber amount
    @paidAmount = amount


  setCurrencyCode: (code) ->
    throw new Error 'Invalid currency code' unless typeof code is 'string'
    @currencyCode = code


  setTransactionFee: (fee) ->
    throw new Error 'Invalid transaction fee' unless check.isNumber fee
    @transactionFee = fee


  setTransactionTime: (time) ->
    throw new Error 'Invalid transaction time' unless time instanceof Date
    @transactionTimestamp = time


  setPayer: (payer) ->
    throw new Error 'Invalid payer' unless check.isObject payer
    @user = payer


  setInvoice: (invoice) ->
    throw new Error 'Invalid invoice' unless check.isObject invoice
    @invoice = invoice


  setAddresses: (addresses) ->
    throw new Error 'Invalid addresses' unless Array.isArray addresses
    @addresses = addresses


module.exports = Transaction
