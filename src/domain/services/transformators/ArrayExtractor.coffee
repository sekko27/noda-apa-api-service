_ = require('lodash')
async = require('async')
Extractor = require './Extractor'

class ArrayExtractor extends Extractor
  constructor: (@selector, @subExtractor, @transformator = null, @default=[]) ->

  run: (doc, callback) ->
    subDocuments = doc.find(@selector, @nsDef())
    async.mapSeries(
      subDocuments,
      (subDocument, cb) =>
        @subExtractor.run subDocument, cb
      (err, result) =>
        return setImmediate(->callback(err)) if err
        return @transformator.transform(result, callback) if @transformator
        setImmediate(->callback(null, result))
    )

module.exports = ArrayExtractor