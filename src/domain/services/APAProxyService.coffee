class APAProxyService
  #Inject service
  #Inject grid

  exists: (itemId, callback) ->
    @grid.exists itemId:itemId, callback

  get: (itemId, callback) ->
    @exists itemId, (err, found) =>
      return callback(err) if err
      return @fetch(itemId, callback) if not found
      @grid.createRead
