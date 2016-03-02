class APAProxyService
  #Inject cache

  itemLookup: (asin, callback) ->
    @cache.get ItemId: asin, callback

  batchItemLookup: (asin, callback) ->
    @cache.get ItemId: asin, (err, stream) ->
      setImmediate(->callback(err, asin))

  count: (callback) ->
    @cache.count callback

module.exports = APAProxyService
