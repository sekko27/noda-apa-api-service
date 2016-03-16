concat = require 'concat-stream'
XML = require 'libxmljs'
async = require 'async'
_ = require 'lodash'

class MetaService
  #Inject grid
  #Inject logger
  #Inject apaProxyService
  #Inject largeExtractor
  #Inject headerExtractor

  xml: (asin, callback) ->
    @apaProxyService.itemLookup asin, (err, stream) =>
      return setImmediate(->callback(err)) if err
      stream.on 'error', callback
      stream.pipe concat encoding: 'string', (source) =>
        try
          xml = XML.parseXmlString(source)
          setImmediate -> callback null, xml
        catch err
          setImmediate -> callback err

  parseHeader: (asin, callback) ->
    @xml asin, (err, document) =>
      return setImmediate(-> callback(err)) if err
      @headerExtractor.run document, callback

  parseMeta: (asin, callback) ->
    @xml asin, (err, document) =>
      return setImmediate(-> callback(err)) if err
      @largeExtractor.run document, callback

  update: (asin, callback) ->
    @parseHeader asin, (err, meta) =>
      metaUpdate =
        if err
          { isValid: false, itemId: asin, errors: [{code: -1, message: (err?.message?.trim() ? 'Unknown error')}] }
        else
          meta
      @grid.files.update {filename: asin}, {$set: {metadata: {amazon: metaUpdate}}}, (err) ->
        setImmediate -> callback(err, metaUpdate)

  findFilesWithoutMeta: (callback) ->
    @grid.files.find({'metadata.amazon': {$exists: false}}).toArray callback

  validStoreAsins: (callback) ->
    @grid.files.find({'metadata.amazon.isValid': true, 'metadata.amazon.errors':{$size:0}},{filename: 1}).toArray (err, asins) ->
      return setImmediate(->callback(err)) if err
      setImmediate -> callback null, _.map asins, (asin) -> asin.filename

  metaAsins: (callback) ->
    @metaRepository.find {}, {asin:1}, (err, metas) ->
      return setImmediate(->callback(err)) if err
      setImmediate -> callback null, _.map metas, (meta) -> meta.asin

  asinForMissingMeta: (callback) ->
    async.parallel {
      store: (cb) => @validStoreAsins(cb)
      meta:  (cb) => @metaAsins(cb)
    }, (err, result) ->
      return setImmediate(->callback(err)) if err
      setImmediate -> callback null, _.difference result.store, result.meta

  parse: (asin, callback) ->
    @xml asin, (err, xml) =>
      return setImmediate(->callback(err)) if err
      async.parallel {
        header: (cb) => @headerExtractor.run xml, cb
        body: (cb) => @largeExtractor.run xml, cb
      }, callback

  createAllMissingMeta: (callback) ->
    @asinForMissingMeta (err, asins) =>
      return setImmediate(->callback(err)) if err
      @logger.info "Found #{asins.length} missing asin in meta"
      cnt = 0
      all = asins.length
      async.eachSeries(
        asins
        (asin, cb) =>
          cnt++
          @createMeta asin, (err, meta) =>
            # Ignore error
            if err
              @logger.error "[#{cnt}/#{all}] - #{asin} - #{err}"
            else
              @logger.info "[#{cnt}/#{all}] - #{asin} - OK"
            setImmediate(->cb(null, meta))
        (err) -> callback(err, all)
      )

  createMeta: (asin, callback) ->
    @parseMeta asin, (err, meta) =>
      return setImmediate(->callback(err)) if err
      @metaRepository.create(meta, callback)

module.exports = MetaService