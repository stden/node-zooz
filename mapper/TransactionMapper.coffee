Transaction = require '../model/Transaction'

DateMapper = require './DateMapper'

check = require 'check-types'

class TransactionMapper


  @marshall: (transaction) ->
    throw new Error 'Invalid transaction' unless transaction instanceof Transaction

    data = {}
    data.transactionID = transaction.transactionID if transaction.transactionID?
    data.appName = transaction.appName if transaction.appName?
    data.isSandbox = transaction.isSandbox if transaction.isSandbox?
    data.transactionStatus = transaction.transactionStatus if transaction.transactionStatus?
    data.fundSourceType = transaction.fundSourceType if transaction.fundSourceType?
    data.lastFourDigits = transaction.lastFourDigits if transaction.lastFourDigits?
    data.amount = transaction.amount if transaction.amount?
    data.paidAmount = transaction.paidAmount if transaction.paidAmount?
    data.currencyCode = transaction.currencyCode if transaction.currencyCode?
    data.transactionFee = transaction.transactionFee if transaction.transactionFee?
    data.transactionTimestamp = DateMapper.marshall transaction.transactionTimestamp if transaction.transactionTimestamp?
    data.user = transaction.user if transaction.user?
    data.invoice = transaction.invoice if transaction.invoice?
    data.addresses = transaction.addresses if transaction.addresses?

    return data



  @unmarshall: (data) ->
    throw new Error 'Invalid transaction data' unless data? and check.isObject data
    throw new Error 'Invalid transaction data' if check.isEmptyObject data

    transaction = new Transaction data.transactionID
    transaction.setAppName data.appName if data.appName?

    transaction.setIsSandbox JSON.parse(data.isSandbox) if data.isSandbox?
    transaction.setTransactionStatus data.transactionStatus if data.transactionStatus?
    transaction.setFoundSourceType data.fundSourceType if data.fundSourceType?
    transaction.setLastFourDigits data.lastFourDigits if data.lastFourDigits?
    transaction.setOriginalAmount parseFloat(data.amount) if data.amount?
    transaction.setPaidAmount parseFloat(data.paidAmount) if data.paidAmount?
    transaction.setCurrencyCode data.currencyCode if data.currencyCode?
    transaction.setTransactionFee parseFloat(data.transactionFee) if data.transactionFee?
    transaction.setTransactionTime DateMapper.unmarshall(data.transactionTimestamp) if data.transactionTimestamp?
    transaction.setPayer data.user if data.user?
    transaction.setInvoice data.invoice if data.invoice?
    transaction.setAddresses data.addresses if data.addresses?

    return transaction


module.exports = TransactionMapper