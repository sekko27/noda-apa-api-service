md5 = require 'md5'

module.exports = (params, callback) ->
  setImmediate(->callback(null, md5(params)))
