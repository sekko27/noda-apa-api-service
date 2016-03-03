_ = require 'lodash'
async = require 'async'
Extractor = require './Extractor'

class SimpleExtractor extends Extractor
  constructor: (@selector, @default = undefined, @validators = []) ->

  run: (doc, callback) ->
    value = doc.get(@selector, @nsDef())?.text() ? @default
    errors = async.map(
      @validators,
      (validator, cb) -> validator.validate(value, cb)
      (err, result) ->
        return setImmediate(->callback([err])) if err
        result = _.compact errors
        return setImmediate(->callback(result)) if not _.isEmpty(result)
        setImmediate(callback(null, value))
    )

module.exports = SimpleExtractor
