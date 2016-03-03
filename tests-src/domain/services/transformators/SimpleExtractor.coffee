q = require 'q'
_ = require 'lodash'

Helper = require('wire-context-helper').Helper()
Util = require './Util'
chai = require 'chai'
{assert, expect} = chai
SimpleExtractor = require Helper.service('transformators/SimpleExtractor')

describe 'Simple extractor', ->
  context = null
  document = null

  before (done) ->
    Util.initAndLoadDocument '5020339644', (err, result) ->
      return done(err) if err
      context = result.ctx
      document = result.document
      done()

  it 'should extract existing simple node', (done) ->
    extractor = new SimpleExtractor '//x:ItemLookupResponse/x:Items/x:Request/x:IsValid', undefined, []
    extractor.run document, (err, response) ->
      assert.isNull err
      assert.equal response, 'True'
      done()