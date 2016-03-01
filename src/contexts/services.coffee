Helper = require('wire-context-helper').Helper()

module.exports =
  apaProvider:
    create:
      module: Helper.service 'APAProvider'
      args: [
        Helper.ref 'apaService'
      ]

  itemLookupCacheKeyResolver:
    module: Helper.service 'APAItemLookupCacheKeyResolver'


  apaProxyService:
    create:
      module: Helper.Service 'APAProxy'
    properties:
      service: Helper.ref 'apaService'
      grid: Helper.ref 'grid'

  gridFSAdapter:
    create:
      module: Helper.infrastructure 'cache/adapters/GridFsAdapter'
      args: []
    properties:
      grid: Helper.ref 'grid'

  apaCache:
    create:
      module: Helper.infrastructure 'cache/Cache'
      args: [
        Helper.ref 'gridFSAdapter'
        Helper.ref 'itemLookupCacheKeyResolver'
        Helper.ref 'apaProvider'
      ]