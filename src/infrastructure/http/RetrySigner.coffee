request = require 'requestretry'
{DefaultSigner} = require 'apa-api'

class RetrySigner
  constructor: (@maxAttempts = 10) ->
    @inner = new DefaultSigner()

  sign: (request) ->
    url: @inner.sign(request)
    maxAttempts: @maxAttempts
    retryDelay: 1000

module.exports = RetrySigner
