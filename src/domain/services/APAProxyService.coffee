class APAProxyService
  #Inject cache

  itemLookup: (asin, callback) ->
    @cache.get @params(asin), callback

  batchItemLookup: (asin, callback) ->
    @cache.get @params(asin), (err, stream) ->
      setImmediate(->callback(err, asin))

  params: (asin) ->
    ItemId: asin, ResponseGroup: 'Large'

  count: (callback) ->
    @cache.count callback

module.exports = APAProxyService
