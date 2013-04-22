module.exports = {
  gateway:           require './lib/gateway'
  TransactionMapper: require './mapper/TransactionMapper'
  Transaction:       require './model/Transaction'
  data:              require './test/data/transaction'
}