module.exports = (apaService, logger) ->
  (params, callback) ->
    callback null, apaService.itemLookup(params, callback)