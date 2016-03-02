class MetaController
  #Inject service
  #Inject logger
  xml: (req, res) ->
    @service.itemLookup req.params.asin, (err, stream) ->
      return req.errorResponse(err) if err
      res.set('Content-Type', 'text/xml')
      stream.pipe(res)

  json: (req, res) ->

module.exports = MetaController
