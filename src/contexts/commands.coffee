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

  fetchCommand:
    create:
      module: Helper.Command('Fetch')
      args: []
    properties:
      logger: Helper.ref 'logger'
      metaService: Helper.ref 'metaService'

  updateFileMetaCommand:
    create:
      module: Helper.Command('UpdateFileMeta')
      args: []
    properties:
      logger: Helper.ref 'logger'
      metaService: Helper.ref 'metaService'

  commandDispatcher:
    create:
      module: Helper.command('CommandDispatcher')
      args: []
    properties:
      logger: Helper.ref('logger')
      commands:
        batch: Helper.ref 'batchCommand'
        fetch: Helper.ref 'fetchCommand'
        updateFileMeta: Helper.ref 'updateFileMetaCommand'


