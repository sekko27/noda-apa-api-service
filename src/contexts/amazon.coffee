Helper = require('wire-context-helper').Helper()

module.exports =
  apaService:
    create:
      module: Helper.infrastructure('factories/APAServiceFactory')
      args: [
        require './apa-api-credentials-secure'
        Helper.ref 'apaSigner'
        Helper.ref 'apaClient'
      ]
  apaSigner:
    create:
      module: Helper.infrastructure('http/RetrySigner')
      args: [
        10
      ]

  apaClient:
    module: 'requestretry'

