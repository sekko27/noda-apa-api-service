_ = require('lodash')
async = require('async')
Extractor = require './Extractor'

class ContextExtractor extends Extractor
  constructor: (@rootSelector, @subExtractors, @default={}) ->

  run: (doc, callback) ->
    rootDocument = doc.get(@rootSelector, @nsDef())
    return setImmediate(->callback(null, @default)) if not rootDocument
    tasks = _.reduce(
      @subExtractors,
      (memo, current) ->
        memo[current.name] = (cb) -> current.extractor.run(rootDocument, cb)
        memo
      {}
    )
    async.parallel(tasks, callback)

module.exports = ContextExtractor


