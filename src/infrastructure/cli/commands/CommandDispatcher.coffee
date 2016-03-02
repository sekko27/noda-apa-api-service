_ = require 'lodash'
optimist = require 'optimist'

class CommandDispatcher
  #Inject commands
  #Inject logger

  run: (callback) ->
    args = optimist.demand('command').alias('cmd', 'command').argv
    commandName = args.command
    if not _.has(@commands, commandName)
      @logger.err "Invalid command: #{commandName}"
      return setImmediate(->callback("Invalid command"))
    @logger.info "Running command: #{commandName}"
    @commands[commandName].run(optimist, callback)

module.exports = CommandDispatcher
