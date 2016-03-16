_ = require 'lodash'
readdirp = require 'readdirp'
Command = require './Command'
async = require 'async'
es = require 'event-stream'
fs = require 'fs'
md5 = require 'md5'
entryAsin = (e) -> e.name.replace /^([^\.]+).*/, "$1"

class MetaCommand extends Command
  #Inject grid
  #Inject logger
  #Inject apaProxyService

  defineArguments: (params) ->
    params
      .usage('Creating meta models from amazon store (xml)\nUsage $0 --command=meta --type=[increment,full]')
      .demand(['command', 'type'])
      .default('type', 'increment')
      .describe('type', 'Synchronizing type: increment or full')
      .describe('command', 'Command (batch)')

  execute: (params, callback) ->
    @metaService.createAllMissingMeta (err, size) => callback err, printResult: => @logger.info "Importing #{size} asins"


module.exports = MetaCommand