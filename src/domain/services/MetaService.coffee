concat = require 'concat-stream'
XML = require 'libxmljs'
async = require 'async'
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
      @headerExtractor.run document, (err, meta) =>
        setImmediate -> callback err, {metadata: {amazon: meta}}

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

  parse: (asin, callback) ->
    @xml asin, (err, xml) =>
      return setImmediate(->callback(err)) if err
      async.parallel {
        header: (cb) => @headerExtractor.run xml, cb
        body: (cb) => @largeExtractor.run xml, cb
      }, callback


module.exports = MetaService