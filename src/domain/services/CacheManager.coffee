class CacheManager
  constructor: (@adapter, @provider) ->
    Object.freeze(@)

  get: (key, callback) ->
    @adapter.exists key, (err, found) =>
      return callback(err) if err
      return @adapter.get(key, callback) if found
      @provider.supply key, (providerError, value) =>
        return callback(providerError) if providerError
        @adapter.set key, value, (setterError) =>
          return callback(setterError) if setterError
          return @adapter.get(key, callback)

  set: (key, value, callback) ->
    @adapter.set key, value, callback

  remove: (key, callback) ->
    @adapter.remove key, callback

module.exports = CacheManager
