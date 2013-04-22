Transaction = require '../model/Transaction'

DateMapper = require './DateMapper'

check = require 'check-types'

class TransactionMapper


  @marshall: (transaction) -> throw new Error 'Not implemented'


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