TransactionMapper = require '../mapper/TransactionMapper'

inputTransactionData = require('./data/transaction').ResponseObject

MockClass = new Object

describe 'api/TransactionMapper', ->

  describe 'marshall', ->
    (-> TransactionMapper.marshall()).should.throw 'Not implemented'

  describe 'unmarshall (data -> model)', ->

    it 'should not unmarshall invalid data', ->
      for invalid in [undefined, null, false, 1.1, NaN, '1121234', [], {}, new Date, ()->]
        (-> TransactionMapper.unmarshall invalid).should.throw 'Invalid transaction data'

    model = TransactionMapper.unmarshall inputTransactionData

    it 'should unmarshall the transaction ID', ->
      model.id.should.equal inputTransactionData.transactionID

    it 'should unmarshall the app name', ->
      model.appName.should.equal inputTransactionData.appName

    it 'should unmarshall the is sandbox', ->
      model.isSandbox.should.equal false

    it 'should unmarshall the transaction status', ->
      model.status.should.equal inputTransactionData.transactionStatus

    it 'should unmarshall the found source type', ->
      model.source.should.equal inputTransactionData.fundSourceType

    it 'should unmarshall the last four digits', ->
      model.lastFourDigits.should.equal inputTransactionData.lastFourDigits

    it 'should unmarshall the original amount', ->
      model.originalAmount.should.equal inputTransactionData.amount

    it 'should unmarshall the paid amount', ->
      model.paidAmount.should.equal inputTransactionData.paidAmount

    it 'should unmarshall the currenct code', ->
      model.currencyCode.should.equal inputTransactionData.currencyCode

    it 'should unmarshall the transaction fee', ->
      model.fee.should.equal inputTransactionData.transactionFee

    it 'should unmarshall the transaction time', ->
      model.time.getTime().should.equal inputTransactionData.transactionTimestamp

    it 'should unmarshall the payer', ->
      model.payer.should.equal inputTransactionData.user

    it 'should unmarshall the invoice', ->
      model.invoice.should.equal inputTransactionData.invoice

    it 'should unmarshall the address', ->
      model.addresses.should.equal inputTransactionData.addresses