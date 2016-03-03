module.exports = (apaService, logger) ->
  (params, callback) ->
    logger.info "Fetching meta data from amazon: #{params.ItemId}"
    console.log params
    callback null, apaService.itemLookup(params, callback)