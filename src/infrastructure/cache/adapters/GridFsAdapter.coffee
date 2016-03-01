class GridFsAdapter
  #Inject grid

  exists: (key, callback) ->
    @grid.exist filename: key, callback

  load: (key, callback) ->
    stream = @grid.createReadStream filename: key
    setImmediate -> callback null, stream

  save: (key, value, callback) ->
    console.log 'saving', key
    stream = @grid.createWriteStream(filename: key)
    stream.on 'error', callback
    stream.on 'close', (file) =>
      return callback("file-not-found") if (not file) or (not file?._id)
      setTimeout ( => callback null, @grid.createReadStream _id: file._id), 2000
    value.pipe(stream)

module.exports = GridFsAdapter