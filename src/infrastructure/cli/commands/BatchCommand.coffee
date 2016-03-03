_ = require 'lodash'
readdirp = require 'readdirp'
Command = require './Command'
async = require 'async'
es = require 'event-stream'

class BatchCommand extends Command
  #Inject grid
  #Inject logger
  #Inject apaProxyService

  defineArguments: (params) ->
    params
      .usage('Batch import from fs\nUsage $0 --command=batch --root=[catalog-root]')
      .demand(['command', 'root'])
      .describe('root', 'Root path of the catalog')
      .describe('command', 'Command (batch)')

  createContext: (params, callback) ->
    @logger.info 'Fetching documents from store'
    @grid.files.find({}).toArray (err, files) =>
      return setImmediate(->callback(err)) if err
      asins = _.sortBy _.uniq _.map files, (f) -> f.filename
      entryAsin = (e) -> e.name.replace /^([^\.]+).*/, "$1"
      newCounter = 0
      totalNumber = 0

      callback null,
        numberOfAddedAsins: -> newCounter
        asins: asins
        size: -> asins.length
        entryAsin: entryAsin
        walkingParameters:
          root: params.root
          fileFilter: (e) -> e.name.match(/bz2$/) and (0 > _.sortedIndexOf(asins, entryAsin(e)))
        add: (asin) =>
          if 0 > _.sortedIndexOf(asins, asin)
            asins.push asin
            newCounter++
            @logger.info "Adding new asin [#{newCounter} / #{totalNumber}]: #{asin}"
        logger: @logger
        service: @apaProxyService
        setTotal: (total) -> totalNumber = total
        printResult: =>
          @logger.info "#{newCounter} new asins have been added to the meta store"

  execute: (params, callback) ->
    @logger.info 'Executing batch command'
    @createContext params, (err, ctx) =>
      return setImmediate(->callback(err)) if err
      @executeContext params, ctx, callback

  executeContext: (params, ctx, callback) ->
    @logger.info "We have #{ctx.size()} already fetched meta document in the meta store"
    @logger.info "Start scanning #{params.root}"

    readdirp(ctx.walkingParameters, undefined, undefined)
      .on 'warn', (err) -> ctx.logger.warn err
      .on 'error', (err) -> ctx.logger.err err
      .on 'end', -> ctx.logger.info 'Recursive walking has been finished'
      .pipe es.mapSync ctx.entryAsin
      .pipe es.writeArray (err, arr) ->
        ctx.logger.info "Start fetching #{arr.length} asins"
        ctx.setTotal arr.length
        return setImmediate(->callback(err)) if err
        async.eachSeries(
          arr
          (asin, cb) ->
            ctx.service.batchItemLookup asin, (err) ->
              return setImmediate(->cb(err)) if err
              ctx.add asin
              setTimeout(cb, 2000)
          (err) ->
            setImmediate(->callback(err, ctx))
      )

module.exports = BatchCommand