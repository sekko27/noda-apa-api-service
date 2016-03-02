class MetaController
  #Inject service
  #Inject logger
  xml: (req, res) ->
    @service.itemLookup req.params.asin, (err, stream) ->
      return req.errorResponse(err) if err
      res.set('Content-Type', 'text/xml')
      stream.pipe(res)

  json: (req, res) ->

  count: (req, res) ->
    @service.count (err, cnt) ->
      return res.errorResponse(err) if err
      res.json(count: cnt)

module.exports = MetaController
