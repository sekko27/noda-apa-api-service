_ = require 'lodash'
core = require './index'
readdirp = require 'readdirp'
es = require 'event-stream'
through = require 'through2'
async = require 'async'

core.then (ctx) ->
  console.log 'Start scanning'

  error = (err) ->
    console.log err
    process.exit(1)

  entryAsin = (e) -> e.name.replace /^([^\.]+).*/, "$1"

  ctx.grid.files.find({}).toArray (err, files) ->
    return error(err) if err

    asins = _.map files, (f) -> f.filename

    filter = (e) ->
      asin = entryAsin(e)
      e.name.match(/bz2$/) and (0 > _.indexOf asins, asin)

    readdirp({root: '/bb/Collection/catalog/4', fileFilter: filter})
      .on 'warn', (err) -> ctx.logger.warn err
      .on 'error', (err) -> ctx.logger.err err
      .on 'end', -> console.log 'done'
      .pipe es.mapSync (e) -> e.name.replace /^([^\.]+).*/, "$1"
      .pipe es.writeArray (err, arr) ->
        return if err
        async.eachSeries(
          arr
          (asin, cb) -> ctx.apaProxyService.batchItemLookup(asin, cb)
          (err) ->
            console.log 'error', err
            process.exit(0)
        )