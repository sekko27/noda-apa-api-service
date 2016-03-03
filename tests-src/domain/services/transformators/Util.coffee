Helper = require('wire-context-helper').Helper()
{Runner} = require 'wire-context-helper'
concat = require 'concat-stream'
XML = require 'libxmljs'

Util =
  initialize: (callback) ->
    spec = require Helper.context 'test-spec'
    Runner spec, callback

  loadDocument: (ctx, asin, callback) ->
    ctx.apaProxyService.itemLookup asin, (err, stream) ->
      return callback(err) if err
      stream.on 'error', callback
      stream.pipe concat encoding: 'string', (result) ->
        document = XML.parseXml(result)
        callback(null, document)

  initAndLoadDocument: (asin, callback) ->
    Util.initialize (err, ctx) ->
      return callback(err) if err
      Util.loadDocument ctx, asin, (err, document) ->
        return callback(err) if err
        callback(null, ctx: ctx, document: document)

module.exports = Util
