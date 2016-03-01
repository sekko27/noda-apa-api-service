module.exports = (apaService) ->
  (params, callback) ->
    setImmediate -> callback null, apaService.itemLookup(params)