apa = require 'apa-api'

module.exports = (credentials, signer, client) ->
  {Service, APIMeta, Credential} = apa
  new Service(new APIMeta(), new Credential(credentials), signer, client)
