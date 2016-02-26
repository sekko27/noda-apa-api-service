Helper = require('wire-context-helper').Helper()

module.exports =
  apaApi:
    module: 'apa-api'

  apaMeta:
    sub:
      module: 'apaApi#APIMeta'
      args: []

  apaCredentials:
    sub:
      module: 'apaApi#Credential'
      args: [
        require './apa-api-credentials-secure'
      ]

  apaService:
    sub:
      module: 'apaApi#Service'
      args: [
        Helper.ref 'apaMeta'
        Helper.ref 'apaCredentials'
      ]

