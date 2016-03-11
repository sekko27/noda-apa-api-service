_ = require('lodash')
async = require('async')
Extractor = require './Extractor'

class ContextExtractor extends Extractor
  constructor: (@rootSelector, @subExtractors, @transformator = null, @default={}) ->

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
    async.series(
      tasks
      (err, result) =>
        return setImmediate(->callback(err)) if err
        return @transformator.transform(result, callback) if @transformator
        setImmediate(->callback(null, result))
    )

module.exports = ContextExtractor


