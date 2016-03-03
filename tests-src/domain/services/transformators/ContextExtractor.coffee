q = require 'q'
_ = require 'lodash'

Helper = require('wire-context-helper').Helper()
Util = require './Util'
chai = require 'chai'
{assert, expect} = chai
SimpleExtractor = require Helper.service('transformators/SimpleExtractor')
ContextExtractor = require Helper.service('transformators/ContextExtractor')

describe 'Simple extractor', ->
  context = null
  document = null

  before (done) ->
    Util.initAndLoadDocument '5020339644', (err, result) ->
      return done(err) if err
      context = result.ctx
      document = result.document
      done()

  it 'should extract existing complex node', (done) ->
    extractor = new ContextExtractor(
      '//x:ItemLookupResponse/x:Items/x:Request/x:ItemLookupRequest'
      [
        {
          name: 'IdType'
          extractor: new SimpleExtractor 'x:IdType'
        }
        {
          name: 'ItemId'
          extractor: new SimpleExtractor 'x:ItemId'
        }
        {
          name: 'ResponseGroup'
          extractor: new SimpleExtractor 'x:ResponseGroup'
        }
      ]
    )
    extractor.run document, (err, response) ->
      assert.isNull err
      assert.deepEqual response, IdType: 'ASIN', ItemId: '5020339644', ResponseGroup: 'Large'
      done()