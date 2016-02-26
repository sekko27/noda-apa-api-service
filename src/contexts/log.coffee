Helper = require('wire-context-helper').Helper()

module.exports =
  winston:
    module: 'winston'

  consoleTransporter:
    sub:
      module: 'helper#beans.ConsoleTransporterFactory'
      args: [
        Helper.ref 'winston'
        {
          level: Helper.envVar 'NODE_LOG_LEVEL', 'info'
        }
      ]

  logger:
    sub:
      module: 'helper#beans.WinstonLoggerFactory'
      args: [
        Helper.ref 'winston'
        transporters: [
          Helper.ref 'consoleTransporter'
        ]
      ]
      