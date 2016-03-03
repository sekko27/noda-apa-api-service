_ = require('lodash')
async = require('async')
Extractor = require './Extractor'

class ArrayExtractor extends Extractor
  constructor: (@selector, @subExtractor, @default=[]) ->

  run: (doc, callback) ->
    subDocuments = doc.find(@selector, @nsDef())
    async.map(
      subDocuments,
      (subDocument, cb) =>
        @subExtractor.run subDocument, cb
      callback
    )

module.exports = ArrayExtractor