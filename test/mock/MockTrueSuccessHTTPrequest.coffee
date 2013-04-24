module.exports = (body, callback) ->
  return callback null, {}, JSON.stringify({"ResponseObject":true})