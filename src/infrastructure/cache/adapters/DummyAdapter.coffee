fs = require 'fs'

class DummyAdapter

  exists: (key, callback) ->
    setImmediate(->callback(null, false));

  load: (key, callback) ->
    setImmediate(->callback("not.found.#{key}"))

  save: (key, value, callback) ->
    setImmediate(->callback(null, value))

  count: (callback) ->
    setImmediate(->callback(null, 0))

module.exports = DummyAdapter