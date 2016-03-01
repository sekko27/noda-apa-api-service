module.exports = (apaService, logger) ->
  (params, callback) ->
    logger.info 'Fetching meta data', params
    callback null, apaService.itemLookup(params, callback)