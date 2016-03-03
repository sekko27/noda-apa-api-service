Helper = require('wire-context-helper').Helper()

module.exports =
  imageModel:
    create:
      module: Helper.model('Image')
      args: [
        Helper.ref 'mongoose'
        Helper.ref 'storageConnection'
      ]

  imageSetModel:
    create:
      module: Helper.model('ImageSet')
      args: [
        Helper.ref 'mongoose'
        Helper.ref 'imageModel'
      ]

  linkModel:
    create:
      module: Helper.model('Link')
      args: []

  metaModel:
    create:
      module: Helper.model('Meta')
      args: [
        Helper.ref 'mongoose'
        Helper.ref 'storageConnection'
        Helper.ref 'linkModel'
        Helper.ref 'imageSetModel'
        Helper.ref 'imageModel'
      ]


