class GridFsAdapter
  #Inject grid

  exists: (key, callback) ->
    @grid.exists key, callback

  load: (key, callback) ->
    stream = @grid.createReadStream key
    setImmediate -> callback null, stream

  save: (key, value, callback) ->
    stream = @grid.createWriteStream(key)
    stream.on 'error', callback
    stream.on 'close', (file) =>
      return callback("file-not-found") if (not file) or (not file?._id)
      setImmediate -> callback null, @grid.createReadStream _id: file._id

module.exports = GridFsAdapter