_ = require 'lodash'
Command = require './Command'
async = require 'async'
concat = require 'concat-stream'
XML = require 'libxmljs'

class UpdateFileMetaCommand extends Command
  #Inject metaService
  #Inject logger

  defineArguments: (params) ->
    params
    .usage('Single fetch by asin\nUsage $0 --command=fetch --asin=[asin]')
    .demand(['command'])
    .describe('command', 'Command (fetch)')

  execute: (params, callback) ->
    @metaService.findFilesWithoutMeta (err, files) =>
      async.eachLimit(
        files
        5
        (file, cb) =>
          asin = file.filename
          @metaService.update asin, (err, meta) =>
            if err then @logger.error(asin, err.message) else @logger.info(meta)
            setImmediate(->cb(null)) #Ignoring error
        (err) =>
          setImmediate => callback err, printResult: => @logger.info "Updated #{files.length} meta"
      )

module.exports = UpdateFileMetaCommand