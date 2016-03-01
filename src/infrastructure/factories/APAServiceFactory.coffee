apa = require 'apa-api'

module.exports = (credentials) ->
  {Service, APIMeta, Credential} = apa
  new Service(new APIMeta(), new Credential(credentials))
