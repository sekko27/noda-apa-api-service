Helper = require('wire-context-helper').Helper()

module.exports =
  apaProxyService:
    create:
      module: Helper.Service 'APAProxy'
    properties:
      service: Helper.ref 'apaService'
      grid: Helper.ref 'grid'
