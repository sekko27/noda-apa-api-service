_ = require 'lodash'
async = require 'async'
Extractor = require './Extractor'

class SimpleExtractor extends Extractor
  constructor: (@selector, @defaultValue = 0, @defaultUnit = 'unknown', @transformator = null) ->

  run: (doc, callback) ->
    node = doc.get(@selector, @nsDef())
    value = node?.text() ? @defaultValue
    unit = node?.attr('Units')?.value() ? @defaultUnit
    result = value: value, unit: unit
    return @transformator.transform(result, callback) if @transformator
    setImmediate(->callback(null, result))

module.exports = SimpleExtractor
