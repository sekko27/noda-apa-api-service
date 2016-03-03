_ = require 'lodash'
async = require 'async'
Extractor = require './Extractor'

class SimpleExtractor extends Extractor
  constructor: (@selector, @default = undefined, @transformator = null) ->

  run: (doc, callback) ->
    value = doc.get(@selector, @nsDef())?.text() ? @default
    return @transformator.transform(value, callback) if @transformator
    setImmediate(->callback(null, value))

module.exports = SimpleExtractor
