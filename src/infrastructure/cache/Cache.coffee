async = require 'async'
ifAsync = require 'if-async'

class Cache
  constructor: (@adapter, @keyResolver, @provider) ->

  get: (params, callback) ->
    async.waterfall([
      (cb) => @keyResolver(params, cb)
      ifAsync (key, cb) => @adapter.exists(key, cb)
        .then (key, cb) => @adapter.load(key, cb)
        .else (key, cb) =>
          async.waterfall([
            (loadCallback) => @provider(key, params, loadCallback)
            (value, loadCallback) => @adapter.save(key, value, loadCallback)
          ], cb)
    ], callback)