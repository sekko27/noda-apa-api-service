Helper = require('wire-context-helper').Helper()

module.exports =
  apaProvider:
    create:
      module: Helper.service 'APAProvider'
      args: [
        Helper.ref 'apaService'
        Helper.ref 'logger'
      ]

  itemLookupCacheKeyResolver:
    module: Helper.service 'APAItemLookupCacheKeyResolver'


  apaProxyService:
    create:
      module: Helper.Service 'APAProxy'
    properties:
      cache: Helper.ref 'apaCache'

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

  imageService:
    create:
      module: Helper.Service 'Image'
    properties:
      logger: Helper.ref 'logger'
      repository: Helper.ref 'imageRepository'

  browseNodeService:
    create:
      module: Helper.Service 'BrowseNode'
    properties:
      logger: Helper.ref 'logger'
      repository: Helper.ref 'browseNodeRepository'

  imageResolverTransformator:
    create:
      module: Helper.service 'transformators/ImageResolverTransformator'
    properties:
      imageService: Helper.ref 'imageService'

  browseNodeTransformator:
    create:
      module: Helper.service 'transformators/BrowseNodeTransformator'
    properties:
      browseNodeService: Helper.ref 'browseNodeService'

  largeExtractor:
    create:
      module: Helper.service 'transformators/LargeExtractorFactory'
      args: [
        Helper.ref 'imageResolverTransformator'
        Helper.ref 'browseNodeTransformator'
      ]

  headerExtractor:
    create:
      module: Helper.service 'transformators/HeaderExtractorFactory'
      args: [ ]

  metaService:
    create:
      module: Helper.Service('Meta')
      args: []
    properties:
      logger: Helper.ref 'logger'
      grid: Helper.ref 'grid'
      apaProxyService: Helper.ref 'apaProxyService'
      headerExtractor: Helper.ref 'headerExtractor'
      largeExtractor: Helper.ref 'largeExtractor'
