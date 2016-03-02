module.exports = (apaService, logger) ->
  (params, callback) ->
    logger.info "Fetching meta data from amazon: #{params.ItemId}"
    callback null, apaService.itemLookup(params, callback)