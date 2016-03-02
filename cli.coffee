_ = require 'lodash'
core = require './index'
readdirp = require 'readdirp'
es = require 'event-stream'
through = require 'through2'
async = require 'async'

core.then (ctx) ->
  ctx.commandDispatcher.run (err, resultContext) ->
    if err
      ctx.logger.err(err)
      process.exit(1)
    else
      resultContext.printResult()
      process.exit(0)

