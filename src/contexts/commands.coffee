Helper = require('wire-context-helper').Helper()

module.exports =
  batchCommand:
    create:
      module: Helper.Command('Batch')
      args: []
    properties:
      logger: Helper.ref('logger')
      grid: Helper.ref('grid')
      apaProxyService: Helper.ref('apaProxyService')

  commandDispatcher:
    create:
      module: Helper.command('CommandDispatcher')
      args: []
    properties:
      logger: Helper.ref('logger')
      commands:
        batch: Helper.ref 'batchCommand'

