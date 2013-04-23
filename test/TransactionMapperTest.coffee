TransactionMapper = require '../mapper/TransactionMapper'

inputTransactionData = require('./data/transaction').USD.ResponseObject

MockClass = new Object

describe 'api/TransactionMapper', ->

  describe 'unmarshall (data -> model)', ->

    it 'should not unmarshall invalid data', ->
      for invalid in [undefined, null, false, 1.1, NaN, '1121234', [], {}, new Date, ()->]
        (-> TransactionMapper.unmarshall invalid).should.throw 'Invalid transaction data'

    model = TransactionMapper.unmarshall inputTransactionData

    it 'should unmarshall the transaction ID', ->
      model.transactionID.should.equal inputTransactionData.transactionID

    it 'should unmarshall the app name', ->
      model.appName.should.equal inputTransactionData.appName

    it 'should unmarshall the is sandbox', ->
      model.isSandbox.should.equal false

    it 'should unmarshall the transaction status', ->
      model.transactionStatus.should.equal inputTransactionData.transactionStatus

    it 'should unmarshall the found source type', ->
      model.fundSourceType.should.equal inputTransactionData.fundSourceType

    it 'should unmarshall the last four digits', ->
      model.lastFourDigits.should.equal inputTransactionData.lastFourDigits

    it 'should unmarshall the original amount', ->
      model.amount.should.equal inputTransactionData.amount

    it 'should unmarshall the paid amount', ->
      model.paidAmount.should.equal inputTransactionData.paidAmount

    it 'should unmarshall the currenct code', ->
      model.currencyCode.should.equal inputTransactionData.currencyCode

    it 'should unmarshall the transaction fee', ->
      model.transactionFee.should.equal inputTransactionData.transactionFee

    it 'should unmarshall the transaction time', ->
      model.transactionTimestamp.getTime().should.equal inputTransactionData.transactionTimestamp

    it 'should unmarshall the payer', ->
      model.user.should.equal inputTransactionData.user

    it 'should unmarshall the invoice', ->
      model.invoice.should.equal inputTransactionData.invoice

    it 'should unmarshall the address', ->
      model.addresses.should.equal inputTransactionData.addresses

# ------------------------------------------------------------------------------------

  describe 'marshall', ->

    data = TransactionMapper.marshall TransactionMapper.unmarshall inputTransactionData

    it 'should marshall the transaction ID', ->
      data.transactionID.should.equal inputTransactionData.transactionID

    it 'should marshall the app name', ->
      data.appName.should.equal inputTransactionData.appName

    it 'should marshall the is sandbox', ->
      data.isSandbox.should.equal false

    it 'should marshall the transaction status', ->
      data.transactionStatus.should.equal inputTransactionData.transactionStatus

    it 'should marshall the found source type', ->
      data.fundSourceType.should.equal inputTransactionData.fundSourceType

    it 'should marshall the last four digits', ->
      data.lastFourDigits.should.equal inputTransactionData.lastFourDigits

    it 'should marshall the original amount', ->
      data.amount.should.equal inputTransactionData.amount

    it 'should marshall the paid amount', ->
      data.paidAmount.should.equal inputTransactionData.paidAmount

    it 'should marshall the currenct code', ->
      data.currencyCode.should.equal inputTransactionData.currencyCode

    it 'should marshall the transaction fee', ->
      data.transactionFee.should.equal inputTransactionData.transactionFee

    it 'should marshall the transaction time', ->
      data.transactionTimestamp.should.equal inputTransactionData.transactionTimestamp

    it 'should marshall the payer', ->
      data.user.should.equal inputTransactionData.user

    it 'should marshall the invoice', ->
      data.invoice.should.equal inputTransactionData.invoice

    it 'should marshall the address', ->
      data.addresses.should.equal inputTransactionData.addresses
