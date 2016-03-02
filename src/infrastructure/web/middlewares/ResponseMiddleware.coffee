_ = require 'lodash'

module.exports = (logger) ->
  (req, res, next) ->
    mixin =
      reqCtx: ->
        url: req.url
        cat: 'response'

      errorResponse: (err, code = 500) ->
        logger.error err, err?.stack, mixin.reqCtx()
        res.status(code).send(err)

      notFound: (message = undefined, code = 404) ->
        logger.warn "Resource not found", mixin.reqCtx()
        res.status(code).send(message)

      permissionDenied: ->
        logger.error 'Requested resource operation is not permitted', mixin.reqCtx()
        res.status(550).send()

      listResult: (handler, code = 200) ->
        (err, result...) ->
          return mixin.errorResponse(err) if err
          if handler
            return handler null, result...
          res.status(code).json(result[0])

      asyncListResult: (handler, code = 200) ->
        (err, result) ->
          return mixin.errorResponse(err) if err
          handler(result, mixin.listResult(undefined, code))

      instanceResult: (handler, code = 200, interceptor = _.identity) ->
        (err, result...) ->
          return mixin.errorResponse(err) if err
          return mixin.notFound() if not result[0]
          if handler
            return handler null, result...
          res.status(code).json(interceptor(result[0]))

      instanceResult0: (handler, code = 200) ->
        mixin.instanceResult ( (noError, result...) -> handler(result...) ), code

      mapInstanceResult: (map, code = 200) ->
        mixin.instanceResult undefined, code, map

      createResult: (emptyResultCode = 204, interceptor = _.identity) ->
        (err, result) ->
          return mixin.errorResponse(err) if err
          return res.status(201).json(interceptor result) if result
          res.status(emptyResultCode).send()

      destroyResult: (emptyResultCode = 204) ->
        (err, result) ->
          return mixin.errorResponse(err) if err
          return res.status(200).json(result) if result
          res.status(emptyResultCode).send()

      patchResult: (responseCode = 200, interceptor = _.identity ) ->
        (err, result) ->
          return mixin.errorResponse(err) if err
          return mixin.notFound() if not result
          res.status(responseCode).json(interceptor result)

      badRequest: (message = undefined) ->
        res.status(400).send(message)

    _.merge res, mixin

    next()

