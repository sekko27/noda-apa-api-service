q = require 'q'
_ = require 'lodash'

Helper = require('wire-context-helper').Helper()
Util = require './Util'
chai = require 'chai'
{assert, expect} = chai
SimpleExtractor = require Helper.service('transformators/SimpleExtractor')
ContextExtractor = require Helper.service('transformators/ContextExtractor')
ArrayExtractor = require Helper.service('transformators/ArrayExtractor')

describe 'Array extractor', ->
  context = null
  document = null

  before (done) ->
    Util.initAndLoadDocument '5020339644', (err, result) ->
      return done(err) if err
      context = result.ctx
      document = result.document
      done()

  it 'should extract existing array node', (done) ->
    linkExtractor = new ContextExtractor(
      '.'
      [
        {
          name: 'Description'
          extractor: new SimpleExtractor 'x:Description'
        }
        {
          name: 'URL'
          extractor: new SimpleExtractor 'x:URL'
        }
      ]
    )
    linksExtractor = new ArrayExtractor '//x:ItemLookupResponse/x:Items/x:Item/x:ItemLinks/x:ItemLink', linkExtractor
    linksExtractor.run document, (err, response) ->
      assert.isNull err
      assert.equal response.length, 7
      assert.isTrue _.every response, (link) ->
        _.has(link, 'Description') and _.has(link, 'URL')
      done()