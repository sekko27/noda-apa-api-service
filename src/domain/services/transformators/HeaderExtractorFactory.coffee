_ = require 'lodash'
ContextExtractor = require './ContextExtractor'
SimpleExtractor = require './SimpleExtractor'
ArrayExtractor = require './ArrayExtractor'

module.exports = () ->
  booleanTransformator = transform: (value, cb) ->
    setImmediate(->cb(null, value == 'True'))

  new ContextExtractor '//x:ItemLookupResponse/x:Items/x:Request', [
    {
      name: 'isValid'
      extractor: new SimpleExtractor 'x:IsValid', 'False', booleanTransformator
    }
    {
      name: 'itemId'
      extractor: new SimpleExtractor 'x:ItemLookupRequest/x:ItemId'
    }
    {
      name: 'errors'
      extractor: new ArrayExtractor 'x:Errors/x:Error', new ContextExtractor '.', [
        {
          name: 'code'
          extractor: new SimpleExtractor 'x:Code'
        }
        {
          name: 'message'
          extractor: new SimpleExtractor 'x:Message'
        }
      ]
    }
  ]