inputTransactionData = require('../data/transaction').USD

module.exports = (body, callback) ->
  return callback null, {}, JSON.stringify(inputTransactionData)