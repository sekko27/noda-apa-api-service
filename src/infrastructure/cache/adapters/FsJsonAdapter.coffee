fs = require 'fs'

class FsJsonAdapter
  #Inject rootFolder

  path: (key) ->
    "#{@rootFolder}/#{key}"

  exists: (key, callback) ->
    fs.access @path(key), fs.R_OK | fs.W_OK, (err) ->
      return setImmediate(->callback(err)) if err
      setImmediate(->callback(null, true))

  load: (key, callback) ->
    fs.readFile @path(key), {encoding: 'utf-8'}, (err, json) ->
      return setImmediate(->callback(err)) if err
      try
        setImmediate(->callback(null, JSON.parse(json)))
      catch parseError
        setImmediate(->callback(parseError))

  save: (key, value, callback) ->
    fs.writeFile @path(key), JSON.stringify(value), (err) ->
      return setImmediate(->callback(err)) if err
      setImmediate(->callback(null, value))

  count: (callback) ->
    setImmediate(->callback("FsJsonAdapter::count is not implemented"))

module.exports = FsJsonAdapter