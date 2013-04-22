Transaction = require '../model/Transaction'

describe 'Transaction', ->

  validTransactionId = '23erfdfsg23r3gt434'

  describe 'contructor', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid transaction id', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setTransactionId invalid).should.throw 'Invalid transaction id'

    describe 'success', ->
      it 'should accept valid transaction id', ->
        (-> tx.setTransactionId validTransactionId).should.not.throw()
        tx.transactionID.should.equal validTransactionId

# ----------------------------------------------------------------------

  describe 'setTransactionId', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid transaction id', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setTransactionId invalid).should.throw 'Invalid transaction id'

    describe 'success', ->
      it 'should accept valid transaction id', ->
        (-> tx.setTransactionId validTransactionId).should.not.throw()
        tx.transactionID.should.equal validTransactionId

# ----------------------------------------------------------------------

  describe 'setAppName', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid app name', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setAppName invalid).should.throw 'Invalid name'
  
    describe 'success', ->
      it 'should accept valid app name', ->
        valid = 'bizzbyapp'
        (-> tx.setAppName valid).should.not.throw()
        tx.appName.should.equal valid

# ----------------------------------------------------------------------

  describe 'setIsSandbox', ->
      tx = new Transaction validTransactionId
      describe 'failures', ->
        it 'should not accept invalid isSandbox', ->
          for invalid in [undefined, null, 1.1, 'true', 'false', [], {}, ()->]
            (-> tx.setIsSandbox invalid).should.throw 'Invalid isSandbox'
    
      describe 'success', ->
        it 'should accept valid isSandbox', ->
          valid = true
          (-> tx.setIsSandbox valid).should.not.throw()
          tx.isSandbox.should.equal valid

          valid = false
          (-> tx.setIsSandbox valid).should.not.throw()
          tx.isSandbox.should.equal valid

# ----------------------------------------------------------------------

  describe 'setTransactionStatus', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid transaction status', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setTransactionStatus invalid).should.throw 'Invalid transaction status'
  
    describe 'success', ->
      it 'should accept valid transaction status', ->
        for valid in ['Pending', 'TPCPending', 'AuthorizationProcess', 'Succeed']
          (-> tx.setTransactionStatus valid).should.not.throw()
          tx.transactionStatus.should.equal valid

# ----------------------------------------------------------------------

  describe 'setFoundSourceType', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid source', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setFoundSourceType invalid).should.throw 'Invalid source'
  
    describe 'success', ->  
      it 'should accept valid source', ->
        for valid in ['VISA', 'MasterCard', 'PayPal']
          (-> tx.setFoundSourceType valid).should.not.throw()
          tx.fundSourceType.should.equal valid

# ----------------------------------------------------------------------

  describe 'setLastFourDigits', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid last four digits', ->
        for invalid in [undefined, null, false, 1.1, 'string', '123', '12345', [], {}, ()->]
          (-> tx.setLastFourDigits invalid).should.throw 'Invalid last four digits'
  
    describe 'success', ->
      it 'should accept valid last four digits', ->
        valid = '1234'
        (-> tx.setLastFourDigits valid).should.not.throw()
        tx.lastFourDigits.should.equal valid

# ----------------------------------------------------------------------

  describe 'setOriginalAmount', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid original amount', ->
        for invalid in [undefined, null, false, 'string', [], {}, ()->]
          (-> tx.setOriginalAmount invalid).should.throw 'Invalid original amount'
  
    describe 'success', ->
      it 'should accept valid original amount', ->
        for valid in [1, 10.1, 100]
          (-> tx.setOriginalAmount valid).should.not.throw()
          tx.amount.should.equal valid

# ----------------------------------------------------------------------

  describe 'setPaidAmount', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid paid amount', ->
        for invalid in [undefined, null, false, 'string', [], {}, ()->]
          (-> tx.setPaidAmount invalid).should.throw 'Invalid paid amount'
  
    describe 'success', ->
      it 'should accept valid paid amount', ->
        for valid in [1, 10.1, 100]
          (-> tx.setPaidAmount valid).should.not.throw()
          tx.paidAmount.should.equal valid

# ----------------------------------------------------------------------

  describe 'setCurrencyCode', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid currency code', ->
        for invalid in [undefined, null, false, 1.1, [], {}, ()->]
          (-> tx.setCurrencyCode invalid).should.throw 'Invalid currency code'
  
    describe 'success', ->
      it 'should accept valid currency code', ->
        for valid in ['GBP']
          (-> tx.setCurrencyCode valid).should.not.throw()
          tx.currencyCode.should.equal valid

# ----------------------------------------------------------------------

  describe 'setTransactionFee', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid transaction fee', ->
        for invalid in [undefined, null, false, 'string', [], {}, ()->]
          (-> tx.setTransactionFee invalid).should.throw 'Invalid transaction fee'
  
    describe 'success', ->
      it 'should accept valid transaction fee', ->
        for valid in [1, 10.1, 100]
          (-> tx.setTransactionFee valid).should.not.throw()
          tx.transactionFee.should.equal valid

# ----------------------------------------------------------------------

  describe 'setTransactionTime', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid time', ->
        for invalid in [undefined, null, false, 1.1, 'string', [], {}, ()->]
          (-> tx.setTransactionTime invalid).should.throw 'Invalid transaction time'
  
    describe 'success', ->
      it 'should accept valid time', ->
        valid = new Date
        (-> tx.setTransactionTime valid).should.not.throw()
        tx.transactionTimestamp.should.equal valid

# ----------------------------------------------------------------------

  describe 'setPayer', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid payer', ->
        for invalid in [undefined, false, 1.1, 'string']
          (-> tx.setPayer invalid).should.throw 'Invalid payer'
  
    describe 'success', ->
      it 'should accept valid payer', ->
        valid = {}
        (-> tx.setPayer valid).should.not.throw()
        tx.user.should.eql valid

# ----------------------------------------------------------------------

  describe 'setInvoice', ->
    tx = new Transaction validTransactionId
    describe 'failures', ->
      it 'should not accept invalid invoice', ->
        for invalid in [undefined, false, 1.1, 'string']
          (-> tx.setInvoice invalid).should.throw 'Invalid invoice'
  
    describe 'success', ->
      it 'should accept valid invoice', ->
        valid = {}
        (-> tx.setInvoice valid).should.not.throw()
        tx.invoice.should.eql valid

# ----------------------------------------------------------------------

  describe 'setAddresses', ->

    tx = new Transaction validTransactionId

    describe 'failures', ->
      it 'should not accept invalid address', ->
        for invalid in [undefined, false, 1.1, 'string']
          (-> tx.setAddresses invalid).should.throw 'Invalid addresses'
  
    describe 'success', ->
      it 'should accept valid address', ->
        valid = []
        (-> tx.setAddresses valid).should.not.throw()
        tx.addresses.should.eql valid