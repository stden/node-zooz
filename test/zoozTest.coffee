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

      call() for call in [undefined, null, false, NaN, 1.1, '1121234', [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as developerId", ->
            (-> new Zooz invalid).should.throw 'Invalid developerId'

      call() for call in [undefined, null, false, NaN, 1.1, '1121234', [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as developerId", ->
            (-> new Zooz {extendedServer:invalid}).should.throw 'Invalid developerId'

      call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as developerId", ->
            (-> new Zooz {extendedServer:{developerId:invalid}}).should.throw 'Invalid developerId'

      call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as serverAPIKey", ->
            (-> new Zooz {extendedServer:{developerId:validAPIkeys.extendedServer.developerId, serverAPIKey:invalid}}).should.throw 'Invalid serverAPIKey'

      call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as ZooZUniqueID", ->
            (-> new Zooz {extendedServer:validAPIkeys.extendedServer, web:{ZooZUniqueID:invalid}}).should.throw 'Invalid ZooZUniqueID'

      call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalid) ->
        () ->
          it "should not accept #{invalid} as ZooZAppKey", ->
            (-> new Zooz {extendedServer:validAPIkeys.extendedServer, web:{ZooZUniqueID:validAPIkeys.web.ZooZUniqueID, ZooZAppKey: invalid }}).should.throw 'Invalid ZooZAppKey'

      call() for call in [false, 1.1, '1121234', [], {}, new Date]. map (invalid) ->
        () ->
          it "should not accept #{invalid} as request", ->
            (-> new Zooz validAPIkeys, invalid).should.throw 'Invalid http client'

      call() for call in [false, 1.1, '1121234', [], {}, new Date].map (invalidTransactionMapper) ->
        () ->
          it "should not accept #{invalidTransactionMapper} as transaction mapper", ->
            (-> new Zooz validAPIkeys, MockSuccessfulHTTPrequest, invalidTransactionMapper).should.throw 'Invalid transaction mapper'

    describe 'defaults', ->

      call() for call in [undefined, null].map (invalid) ->
        () ->
          it "should accept #{invalid} as request", ->
            (-> new Zooz validAPIkeys, invalid).should.not.throw()
            should.exist new Zooz(validAPIkeys, invalid).request

      call() for call in [undefined, null].map (invalid) ->
        () ->
          it "should accept #{invalid} as transaction mapper", ->
            (-> new Zooz validAPIkeys, MockSuccessfulHTTPrequest, invalid).should.not.throw()
            should.exist new Zooz(validAPIkeys, MockSuccessfulHTTPrequest, invalid).transactionMapper

    describe 'success', ->

      (-> new Zooz validAPIkeys, MockFunction, MockFunction, {}).should.not.throw()
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).apiKeys
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).request
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).transactionMapper
      should.exist new Zooz(validAPIkeys, MockFunction, MockFunction).opts


# -------------------------------------------------------------------------------

  describe 'buildExtendedServerRequest', ->

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->].map (invalid) ->
        () ->
          it 'should not accept an invalid body', ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).buildExtendedServerRequest invalid).should.throw 'Invalid body'

    describe 'success', ->

      it 'should return the correct body', ->

        validBody =
          cmd: 'commitTransaction'
          transactionId: '1234234234'
          amount: '54.30'

        options = (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).buildExtendedServerRequest validBody
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

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->].map (invalid) ->
        () ->
          it 'should not accept an invalid body', ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).buildSecuredWebServletRequest invalid).should.throw 'Invalid body'

    describe 'success', ->

      it 'should return the correct body', ->

        validBody =
          cmd: 'openTrx'
          amount: '10'
          currencyCode: 'GBP'
          "user.idNumber": '12312313'
          "invoice.additionalDetails": "34564563456456"

        options = (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).buildSecuredWebServletRequest validBody
        options.should.have.property 'url'
        options.should.have.property 'method'
        options.should.have.property 'encoding'
        options.should.have.property 'strictSSL'
        options.should.have.property 'headers'
        options.headers.should.have.property 'ZooZUniqueID'
        options.headers.should.have.property 'ZooZAppKey'


# -------------------------------------------------------------------------------

  describe 'requestBy', ->

    validEmail = 'john.smith@gmail.com'

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).requestBy validEmail, invalidCallback ).should.throw 'Invalid callback'

      call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date].map (invalidMethod) ->
        () ->
          it "#{invalidMethod} as method", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).requestBy invalidMethod, null, (err, res) ->
              err.should.be.instanceof Error
              err.message.should.equal 'Invalid by method'
              should.not.exist res
              done()

      call() for call in [undefined, null, false, 1.1, [], {}, new Date].map (invalidValue) ->
        () ->
          it "#{invalidValue} as value", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).requestBy 'email', invalidValue, (err, res) ->
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
              (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).requestBy 'email', validEmail, (err, res) ->
                should.not.exist err
                should.exist res
                done()


# -------------------------------------------------------------------------------

  describe 'getTransactionById', ->

    validTransactionId = '3465435634567456'

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionById validTransactionId, invalidCallback ).should.throw 'Invalid callback'
      
      call() for call in [undefined, null, false, 1.1, [], {}, new Date, ()->].map (invalidId) ->
        () ->
          it "should not accept #{invalidId} as id", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionById invalidId, (err, res) ->
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
              (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionById validTransactionId, (err, res) ->
                should.not.exist err
                should.exist res
                done()


# -------------------------------------------------------------------------------

  describe 'getTransactionByEmail', ->

    validEmail = 'john.smith@gmail.com'

    describe 'failures', ->
      
      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionByEmail validEmail, invalidCallback ).should.throw 'Invalid callback'
      
      call() for call in [undefined, null, false, 1.1, '1121234', [], {}, new Date, ()->].map (invalidEmail) ->
        () ->
          it "should not accept #{invalidEmail} as email", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionByEmail invalidEmail, (err, res) ->
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

      call() for call in ['fab@bizzby.com', 'xxxx@xxx.com'].map (validEmail) ->
        () ->
          it "should accept #{validEmail} as email", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).getTransactionByEmail validEmail, (err, res) ->
              should.not.exist err
              should.exist res
              done()


# -------------------------------------------------------------------------------

  describe 'commitTransaction', ->

    validTransactionId = '3465435634567456'

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).commitTransaction validTransactionId, 0, invalidCallback ).should.throw 'Invalid callback'

      call() for call in [undefined, null, false, NaN, 1.1, [], {}, new Date, ()->].map (invalidId) ->
        () ->
          it "should not accept #{invalidId} as transaction id", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).commitTransaction invalidId, 0, (err, res) ->
              err.should.be.instanceof Error
              err.message.should.equal 'Invalid transaction id'
              should.not.exist res
              done()

      call() for call in [false, NaN, -1, '1.1', [], {}, new Date, ()->].map (invalidAmount) ->
        () ->
          it "should not accept #{invalidAmount} as amount", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).commitTransaction validTransactionId, invalidAmount, (err, res) ->
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

    validTransactionId = '3465435634567456'

    describe 'failures', ->
      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).rollbackTransaction validTransactionId, 0, invalidCallback ).should.throw 'Invalid callback'

      call() for call in [undefined, null, false, 1.1, [], {}, new Date, ()->].map (invalidId) ->
        () ->
          it "should not accept #{invalidId} as transaction id", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).rollbackTransaction invalidId, 0, (err, res) ->
              err.should.be.instanceof Error
              err.message.should.equal 'Invalid transaction id'
              should.not.exist res
              done()

      call() for call in [undefined, null, false, '1.1', [], {}, new Date, ()->].map (invalidAmount) ->
        () ->
          it "should not accept #{invalidAmount} as id", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).rollbackTransaction validTransactionId, invalidAmount, (err, res) ->
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
        (new Zooz validAPIkeys, MockTrueSuccessHTTPrequest).rollbackTransaction validTransactionId, 54.40, (err, res) ->
          should.not.exist err
          should.exist res
          done()

# ----------------------------------------------------------------------------------

  describe 'voidTransaction', ->

    validTransactionId = '3465435634567456'

    describe 'failures', ->

      call() for call in [undefined, null, false, 1.1, NaN, new Object, '1121234', [], {}, new Date].map (invalidCallback) ->
        () ->
          it "should not accept #{invalidCallback} as callback", ->
            (-> (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).voidTransaction validTransactionId, invalidCallback ).should.throw 'Invalid callback'

      call() for call in [undefined, null, false, 1.1, [], {}, new Date, ()->].map (invalidId) ->
        () ->
          it "should not accept #{invalidId} as transaction id", (done) ->
            (new Zooz validAPIkeys, MockSuccessfulHTTPrequest).voidTransaction invalidId, (err, res) ->
              err.should.be.instanceof Error
              err.message.should.equal 'Invalid transaction id'
              should.not.exist res
              done()

      it 'returns an error when there is no response body', (done) ->
        (new Zooz validAPIkeys, MockEmptyHTTPrequest).voidTransaction validTransactionId, (err, res) ->
          err.should.be.instanceof Error
          err.message.should.equal 'missing Zooz response'
          should.not.exist res
          done()

    describe 'success', ->

      it 'should return a result', (done) ->
        (new Zooz validAPIkeys, MockTrueSuccessHTTPrequest).voidTransaction validTransactionId, (err, res) ->
          should.not.exist err
          should.exist res
          done()
