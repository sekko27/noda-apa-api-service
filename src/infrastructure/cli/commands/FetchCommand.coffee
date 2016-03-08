_ = require 'lodash'
Command = require './Command'
async = require 'async'
concat = require 'concat-stream'
XML = require 'libxmljs'

class BatchCommand extends Command
  #Inject logger
  #Inject metaService
  #Inject headerExtractor
  #Inject largeExtractor
  defineArguments: (params) ->
    params
    .usage('Single fetch by asin\nUsage $0 --command=fetch --asin=[asin]')
    .demand(['command', 'asin'])
    .describe('asin', 'ASIN code for the book')
    .describe('command', 'Command (fetch)')

  execute: (params, callback) ->
    @logger.info "Executing fetch command: #{params.asin}"
    @metaService.parse String(params.asin), (err, meta) =>
      return setImmediate(->callback(err)) if err
      ctx = @getContext(meta)
      response = printResult: => @logger.info "Fetch result: ", ctx
      setImmediate -> callback err, response

  getContext: (meta) ->
      isValid: meta?.header?.isValid ? false
      itemId: meta?.header?.itemId ? '-'
      authors: meta?.body?.authors ? '-'
      title: meta?.body?.title ? '-'

module.exports = BatchCommand