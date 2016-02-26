q = require 'q'
_ = require 'lodash'

Helper = require('wire-context-helper').Helper()
{Runner} = require 'wire-context-helper'

defer = q.defer()
spec = require Helper.context 'service-spec'

Runner spec, (err, ctx) ->
  return defer.reject(err) if err
  defer.resolve(ctx)

module.exports = defer.promise
