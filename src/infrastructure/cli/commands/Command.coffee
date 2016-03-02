class Command
  parseArguments: (params) ->
    @defineArguments(params).argv

  defineArguments: (params) ->
    params

  run: (params, callback) ->
    @execute @parseArguments(params), callback

  execute: (params, callback) ->
    throw Error("Not implemented")

module.exports = Command