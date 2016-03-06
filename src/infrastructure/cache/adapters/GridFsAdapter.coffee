class GridFsAdapter
  #Inject grid

  exists: (key, callback) ->
    @grid.exist filename: key, callback

  load: (key, callback) ->
    stream = @grid.createReadStream filename: key
    setImmediate -> callback null, stream

  save: (key, value, callback) ->
    stream = @grid.createWriteStream(filename: key)
    stream.on 'error', callback
    stream.on 'close', (file) =>
      return callback("file-not-found") if (not file) or (not file?._id)
      @load key, callback
    value.pipe(stream)

  count: (callback) ->
    @grid.files.count({}, callback)

module.exports = GridFsAdapter