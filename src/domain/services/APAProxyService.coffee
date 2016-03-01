class APAProxyService
  #Inject cache

  itemLookup: (asin, callback) ->
    cache.get itemId: asin, callback

module.exports = APAProxyService
