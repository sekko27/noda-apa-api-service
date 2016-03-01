Helper = require('wire-context-helper').Helper()

module.exports =
  apaService:
    create:
      module: Helper.infrastructure('factories/APAServiceFactory')
      args: [
        require './apa-api-credentials-secure'
      ]


