should = require 'should'
Zooz = require '../lib/gateway'

MockSuccessfulHTTPrequest  = require './mock/MockSuccessfulHTTPrequest'
MockEmptyHTTPrequest       = require './mock/MockEmptyHTTPrequest'
MockTrueSuccessHTTPrequest = require './mock/MockTrueSuccessHTTPrequest'
MockFalseSuccessHTTPrequest = require './mock/MockFalseSuccessHTTPrequest'

MockFunction = new Function

validAPIkeys = {
  extendedServer:
    developerId: 'john@gmail.com'
    serverAPIKey: '111111111'
  web:
    ZooZUniqueID: 'dev.company'
    ZooZAppKey: 'w2353453245234534'
}


describe 'zooz', ->

  describe 'exports', ->

    zooz = require '../.'
    should.exist zooz.gateway
    should.exist zooz.TransactionMapper
    should.exist zooz.Transaction
    should.exist zooz.data

describe 'Gateway', ->

  describe 'static methods', ->

    describe 'getAllowedServerIP', ->

        it 'should return the server list', ->
          Zooz.getAllowedServerIP().should.eql ['195.28.181.179', '91.228.127.99', '91.228.127.100', '195.28.181.191', '195.28.181.192']

# -------------------------------------------------------------------------------

  describe 'contructor', ->

    describe 'failures', ->

      it 'developerId', ->
        for invalid in [undefined, null, false, NaN, 1.1, '1121234', [], {},  new Date, ()->]
          (-> new Zooz invalid).should.throw 'Invalid developerId'
        for invalid in [undefined, null, false, NaN, 1.1, '1121234', [], {},  new Date, ()->]
          (-> new Zooz {extendedServer:invalid}).should.throw 'Invalid developerId'
        for invalid in [undefined, null, false, NaN, 1.1, [], {},  new Date, ()->]
          (-> new Zooz {extendedServer:{developerId:invalid}}).should.throw 'Invalid developerId'

      it 'serverAPIKey', ->
        for invalid in [undefined, null, false, NaN, 1.1, [], {},  new Date, ()->]
          (-> new Zooz {extendedServer:{developerId:validAPIkeys.extendedServer.developerId, serverAPIKey:invalid}}).should.throw 'Invalid serverAPIKey'

      it 'ZooZUniqueID', ->
        for invalid in [undefined, null, false, NaN, 1.1, [], {},  new Date, ()->]
          (-> new Zooz {extendedServer:validAPIkeys.extendedServer, web:{ZooZUniqueID:invalid}}).should.throw 'Invalid ZooZUniqueID'

      it 'ZooZAppKey', ->
        for invalid in [undefined, null, false, NaN, 1.1, [], {},  new Date, ()->]
          (-> new Zooz {extendedServer:validAPIkeys.extendedServer, web:{ZooZUniqueID:validAPIkeys.web.ZooZUniqueID, ZooZAppKey: invalid }}).should.throw 'Invalid ZooZAppKey'

      it 'request', ->
        for invalidRequest in [false, 1.1, '1121234', [], {}, new Date]
          (-> new Zooz validAPIkeys, invalidRequest).should.throw 'Invalid http client'

      it 'transaction mapper', ->
        for invalidTransactionMapper in [false, 1.1, '1121234', [], {}, new Date]
          (-> new Zooz validAPIkeys, MockSuccessfulHTTPrequest, invalidTransactionMapper).should.throw 'Invalid transaction mapper'

    describe 'defaults', ->
      it 'request', ->
        for invalidRequest in [undefined, null]
          (-> new Zooz validAPIkeys, invalidRequest).should.not.throw()
          should.exist new Zooz(validAPIkeys, invalidRequest).request

      it 'transaction mapper', ->
        for invalidTransactionMapper in [undefined, null]
          (-> new Zooz validAPIkeys, MockSuccessfulHTTPrequest, invalidTransactionMapper).should.not.throw()
          should.exist new Zooz(validAPIkeys, MockSuccessfulHTTPrequest, invalidTransactionMapper).transactionMapper

    describe 'success', ->
      (-> new Zooz validAPIkeys, MockFunction, MockFunction, {}).should.not.throw()
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).apiKeys
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).request
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).transactionMapper
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).opts


# -------------------------------------------------------------------------------

  describe 'buildExtendedServerRequest', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest

    describe 'failures', ->
      it 'should not accept an invalid body', ->
        for invalid in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->]
          (-> ZoozObj.buildExtendedServerRequest invalid).should.throw 'Invalid body'

    describe 'success', ->
      it 'should return the correct body', ->
        validBody =
          cmd: 'commitTransaction'
          transactionId: '1234234234'
          amount: '54.30'

        options = ZoozObj.buildExtendedServerRequest validBody
        options.should.have.property 'url'
        options.should.have.property 'method'
        options.should.have.property 'encoding'
        options.should.have.property 'strictSSL'
        options.should.have.property 'headers'
        options.headers.should.have.property 'ZooZDeveloperId'
        options.headers.should.have.property 'ZooZServerAPIKey'
        options.should.have.property 'body'
        options.body.should.be.a 'string'


# -------------------------------------------------------------------------------

  describe 'buildSecuredWebServletRequest', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest

    describe 'failures', ->
      it 'should not accept an invalid body', ->
        for invalid in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->]
          (-> ZoozObj.buildSecuredWebServletRequest invalid).should.throw 'Invalid body'

    describe 'success', ->
      it 'should return the correct body', ->
        validBody =
          cmd: 'openTrx'
          amount: '10'
          currencyCode: 'GBP'
          "user.idNumber": '12312313'
          "invoice.additionalDetails": "34564563456456"

        options = ZoozObj.buildSecuredWebServletRequest validBody
        options.should.have.property 'url'
        options.should.have.property 'method'
        options.should.have.property 'encoding'
        options.should.have.property 'strictSSL'
        options.should.have.property 'headers'
        options.headers.should.have.property 'ZooZUniqueID'
        options.headers.should.have.property 'ZooZAppKey'


# -------------------------------------------------------------------------------

  describe 'requestBy', ->
    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest
    validEmail = 'john.smith@gmail.com'

    describe 'failures', ->
      it 'callback', ->
        for invalidCallback in [undefined, null, false, 1.1, '1121234', [], {}, new Date]
          (-> ZoozObj.requestBy validEmail, invalidCallback ).should.throw 'Invalid callback'
      describe 'should not accept', ->
        call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date].map (invalidMethod) ->
          () ->
            it "#{invalidMethod} as method", (done) ->
              ZoozObj.requestBy invalidMethod, null, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid by method'
                should.not.exist res
                done()

      describe 'should not accept', ->
        call() for call in [undefined, null, false, 1.1, [], {}, new Date].map (invalidValue) ->
          () ->
            it "#{invalidValue} as value", (done) ->
              ZoozObj.requestBy 'email', invalidValue, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid value'
                should.not.exist res
                done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).requestBy 'email', 'fab@bizzby.com', (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->

      describe 'should accept', ->
        call() for call in ['fab@bizzby.com', 'xxxx@xxx.com'].map (validEmail) ->
          () ->
            it "#{validEmail} as email", (done) ->
              ZoozObj.requestBy 'email', validEmail, (err, res) ->
                should.not.exist err
                should.exist res
                done()


# -------------------------------------------------------------------------------

  describe 'getTransactionById', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest
    validTransactionId = '3465435634567456'

    describe 'failures', ->
      it 'callback', ->
        for invalidCallback in [undefined, null, false, 1.1, [], {}, new Date]
          (-> ZoozObj.getTransactionById validTransactionId, invalidCallback ).should.throw 'Invalid callback'
      
      describe 'should not accept', ->
        call() for call in [undefined, null, false, 1.1, [], {}, new Date, ()->].map (invalidId) ->
          () ->
            it "#{invalidId} as id", (done) ->
              ZoozObj.getTransactionById invalidId, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid transaction id'
                should.not.exist res
                done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).getTransactionById validTransactionId, (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->

      describe 'should accept', ->
        call() for call in ['121234234234', '09078956785867'].map (validTransactionId) ->
          () ->
            it "#{validTransactionId} as transaction id", (done) ->
              ZoozObj.getTransactionById validTransactionId, (err, res) ->
                should.not.exist err
                should.exist res
                done()


# -------------------------------------------------------------------------------

  describe 'getTransactionByEmail', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest
    validEmail = 'john.smith@gmail.com'

    describe 'failures', ->
      it 'callback', ->
        for invalidCallback in [undefined, null, false, 1.1, '1121234', [], {}, new Date]
          (-> ZoozObj.getTransactionByEmail validEmail, invalidCallback ).should.throw 'Invalid callback'
      
      describe 'should not accept', ->
        call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->].map (invalidEmail) ->
          () ->
            it "#{invalidEmail} as email", (done) ->
              ZoozObj.getTransactionByEmail invalidEmail, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid email'
                should.not.exist res
                done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).getTransactionByEmail validEmail, (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->

      describe 'should accept', ->
        call() for call in ['fab@bizzby.com', 'xxxx@xxx.com'].map (validEmail) ->
          () ->
            it "#{validEmail} as email", (done) ->
              ZoozObj.getTransactionByEmail validEmail, (err, res) ->
                should.not.exist err
                should.exist res
                done()


# -------------------------------------------------------------------------------

  describe 'commitTransaction', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest
    validTransactionId = '3465435634567456'

    describe 'failures', ->

      it 'callback', ->
        for invalidCallback in [undefined, null, false, 1.1, '1121234', [], {}, new Date]
          (-> ZoozObj.commitTransaction validTransactionId, 0, invalidCallback ).should.throw 'Invalid callback'

      describe 'should not accept', ->
        call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalidId) ->
          () ->
            it "#{invalidId} as transaction id", (done) ->
              ZoozObj.commitTransaction invalidId, 0, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid transaction id'
                should.not.exist res
                done()

      describe 'should not accept', ->
        call() for call in [false, NaN, -1, '1.1', [], {}, new Date, ()->].map (invalidAmount) ->
          () ->
            it "#{invalidAmount} as amount", (done) ->
              ZoozObj.commitTransaction validTransactionId, invalidAmount, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid amount'
                should.not.exist res
                done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).commitTransaction validTransactionId, 54.40, (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->
      it 'should return a result', (done) ->
        (new Zooz validAPIkeys, MockTrueSuccessHTTPrequest).commitTransaction validTransactionId, 54.40, (err, res) ->
          should.not.exist err
          should.exist res
          done()

      it 'should return a result even when amount is not specified', (done) ->
        (new Zooz validAPIkeys, MockTrueSuccessHTTPrequest).commitTransaction validTransactionId, null, (err, res) ->
          should.not.exist err
          should.exist res
          done()


# -------------------------------------------------------------------------------

  describe 'rollbackTransaction', ->

    ZoozObj = new Zooz validAPIkeys, MockSuccessfulHTTPrequest
    validTransactionId = '3465435634567456'

    describe 'failures', ->
      describe 'failures', ->
      it 'callback', ->
        for invalidCallback in [undefined, null, false, 1.1, '1121234', [], {}, new Date]
          (-> ZoozObj.rollbackTransaction validTransactionId, 0, invalidCallback ).should.throw 'Invalid callback'

      describe 'should not accept', ->
        call() for call in [undefined, null, false, 1.1, [], {}, new Date, ()->].map (invalidId) ->
          () ->
            it "#{invalidId} as id", (done) ->
              ZoozObj.rollbackTransaction invalidId, 0, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid transaction id'
                should.not.exist res
                done()


      describe 'should not accept', ->
        call() for call in [undefined, null, false, '1.1', [], {}, new Date, ()->].map (invalidAmount) ->
          () ->
            it "#{invalidAmount} as id", (done) ->
              ZoozObj.rollbackTransaction validTransactionId, invalidAmount, (err, res) ->
                err.should.be.instanceof Error
                err.message.should.equal 'Invalid amount'
                should.not.exist res
                done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).rollbackTransaction validTransactionId, 54.40, (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->
      it 'should return a result', (done) ->
        ZoozObj.rollbackTransaction validTransactionId, 54.40, (err, res) ->
          should.not.exist err
          should.exist res
          done()
