_ = require 'lodash'

module.exports = (params, callback) ->
  return setImmediate(->callback("No item id is defined")) if not _.has(params, 'itemId')
  setImmediate callback null, params.itemId