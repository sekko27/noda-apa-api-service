q = require 'q'
_ = require 'lodash'
util = require 'util'

Helper = require('wire-context-helper').Helper()
Util = require './Util'
chai = require 'chai'
{assert, expect} = chai

describe 'Array extractor', ->
  context = null
  document = null

  before (done) ->
    Util.initAndLoadDocument '1783287314', (err, result) ->
      return done(err) if err
      context = result.ctx
      document = result.document
      done()

  it 'should extract', (done) ->
    context.largeExtractor.run document, (err, result) ->
      console.log err, result
      done()