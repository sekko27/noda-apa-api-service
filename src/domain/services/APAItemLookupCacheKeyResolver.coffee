_ = require 'lodash'

module.exports = (params, callback) ->
  return setImmediate(->callback("No item id is defined (ItemId)")) if not _.has(params, 'ItemId')
  setImmediate -> callback null, params.ItemId