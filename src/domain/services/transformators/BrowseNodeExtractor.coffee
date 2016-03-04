_ = require 'lodash'
Extractor = require './Extractor'
SimpleExtractor = require './SimpleExtractor'
ArrayExtractor = require './ArrayExtractor'
ContextExtractor = require './ContextExtractor'
async = require 'async'

class BrowseNodeExtractor extends Extractor
  constructor: ->
    @idExtractor = new SimpleExtractor 'x:BrowseNodeId'
    @nameExtractor = new SimpleExtractor 'x:Name'
    @categoryExtractor = new SimpleExtractor 'x:IsCategoryRoot', '0', transform: (value, callback) -> setImmediate(->callback(null, value == '1'))
    @ancestorExtractor = -> new ArrayExtractor 'x:Ancestors/x:BrowseNode', new BrowseNodeExtractor()

  run: (doc, callback) ->
    extractor = new ContextExtractor '.', [
      { name: 'id', extractor: @idExtractor }
      { name: 'name', extractor: @nameExtractor }
      { name: 'category', extractor: @categoryExtractor }
      { name: 'parents', extractor: @ancestorExtractor()}
    ]
    extractor.run doc, (err, result) =>
      return setImmediate(->callback(err)) if err
      mapper = (item) ->
        parents = if _.isArray(item.parents) then _.flatMap(item.parents) else []
        parent = _.last(parents) ? null
        current =
          id: item.id
          name: item.name
          category: item.category
          parent: parent?.id ? null
        parents.concat [current]
      setImmediate -> callback null, mapper(result)

module.exports = BrowseNodeExtractor