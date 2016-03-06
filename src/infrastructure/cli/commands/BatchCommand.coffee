_ = require 'lodash'
readdirp = require 'readdirp'
Command = require './Command'
async = require 'async'
es = require 'event-stream'
fs = require 'fs'
md5 = require 'md5'
entryAsin = (e) -> e.name.replace /^([^\.]+).*/, "$1"

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

  storedAsins: (callback) ->
    @logger.info 'Fetching documents from store'
    @grid.files.find({}).toArray (err, files) =>
      return setImmediate(->callback(err)) if err
      asins = _.sortBy _.uniq _.map files, (f) -> f.filename
      setImmediate -> callback null, asins

  createContext: (params, callback) ->
    @storedAsins (err, asins) =>
      return setImmediate(->callback(err)) if err
      newCounter = 0
      totalNumber = 0

      callback null,
        numberOfAddedAsins: -> newCounter
        asins: asins
        size: -> asins.length
        walkingParameters:
          root: params.root
          fileFilter: (e) -> e.name.match(/bz2$/)
        filter: (asin) ->
          0 > _.sortedIndexOf(asins, asin)
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

    walkingCachePath = "cache/#{md5(ctx.walkingParameters.root)}"
    fs.exists walkingCachePath, (exists) =>
      if exists
        @executeFromCache(walkingCachePath, params, ctx, callback)
      else
        @executeByWalking(walkingCachePath, params, ctx, callback)

  executeByWalking: (cachePath, params, ctx, callback) ->
    readdirp(ctx.walkingParameters, undefined, undefined)
      .on 'warn', (err) -> ctx.logger.warn err
      .on 'error', (err) -> ctx.logger.error err
      .on 'end', -> ctx.logger.info 'Recursive walking has been finished'
      .pipe es.mapSync entryAsin
      .pipe es.writeArray (err, arr) =>
        return setImmediate(->callback(err)) if err
        fs.writeFile cachePath, JSON.stringify(arr), (err) =>
          return setImmediate(->callback(err)) if err
          @loadItems(arr, params, ctx, callback)

  executeFromCache: (cachePath, params, ctx, callback) ->
    ctx.logger.info "Load asins from cache [#{cachePath}]"
    fs.readFile cachePath, encoding: 'utf-8', (err, content) =>
      return setImmediate(->callback(err)) if err
      arr = JSON.parse(content)
      @loadItems arr, params, ctx, callback

  loadItems: (items, params, ctx, callback) ->
    arr = _.filter items, ctx.filter
    ctx.logger.info "Start fetching total=#{items.length}, filtered=#{arr.length} asins"
    ctx.setTotal arr.length
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