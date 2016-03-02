q = require 'q'
_ = require 'lodash'

Helper = require('wire-context-helper').Helper()
{Runner} = require 'wire-context-helper'

defer = q.defer()
spec = require Helper.context 'web-spec'

Runner spec, (err, ctx) ->
  console.log _.keys(ctx)
  ctx.webApp.listen 3000, (err) ->
    if err
      ctx.logger.err err
      defer.reject(err)
    else
      ctx.logger.info 'Web application has been started'
      defer.resolve(ctx)

