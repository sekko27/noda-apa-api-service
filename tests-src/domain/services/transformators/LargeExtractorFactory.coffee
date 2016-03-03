q = require 'q'
_ = require 'lodash'
util = require 'util'

Helper = require('wire-context-helper').Helper()
Util = require './Util'
chai = require 'chai'
{assert, expect} = chai
LargeExtractorFactory = require Helper.service('transformators/LargeExtractorFactory')

describe 'Array extractor', ->
  context = null
  document = null

  before (done) ->
    Util.initAndLoadDocument '5020339644', (err, result) ->
      return done(err) if err
      context = result.ctx
      document = result.document
      done()

  it 'should extract', (done) ->
    extractor = LargeExtractorFactory()
    extractor.run document, (err, result) ->
      console.log util.inspect result, depth: null
      done()