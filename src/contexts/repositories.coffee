Helper = require('wire-context-helper').Helper()

module.exports =
  imageRepository:
    create:
      module: Helper.Repository('')
      args: [
        Helper.ref 'imageModel'
      ]

  metaRepository:
    create:
      module: Helper.Repository('')
      args: [
        Helper.ref 'metaModel'
      ]

  browseNodeRepository:
    create:
      module: Helper.Repository('')
      args: [
        Helper.ref 'browseNodeModel'
      ]