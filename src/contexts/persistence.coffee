Helper = require('wire-context-helper').Helper()

module.exports =
  mongooseModule:
    module: 'mongoose'

  mongooseLogger:
    sub:
      module: 'helper#beans.MongooseLogger'
      args: Helper.refs ['logger']

  mongoose:
    sub:
      module: 'helper#beans.MongooseInitializer'
      args: [
        Helper.ref 'mongooseModule'
        if Helper.envVar('NODE_MONGOOSE_LOGGER', false) then Helper.ref('mongooseLogger') else false
      ]

  storageConnection:
    sub:
      module: 'helper#beans.MongooseConnectionFactory'
      args: [
        Helper.ref 'mongoose'
        connection:
          url: Helper.envVar 'NODE_MONGOOSE_CONNECTION', 'mongodb://localhost:29017/apa-api-service'
      ]

  gridfs:
    module: 'gridfs-stream'

  grid:
    sub:
      module: 'helper#beans.GridFSConnectionFactory'
      args: [
        Helper.ref 'gridfs'
        Helper.ref 'storageConnection'
        Helper.ref 'mongoose'
      ]