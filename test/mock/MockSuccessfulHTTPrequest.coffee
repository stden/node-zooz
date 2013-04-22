inputTransactionData = require '../data/transaction'

module.exports = (body, callback) ->
  return callback null, {}, JSON.stringify(inputTransactionData)