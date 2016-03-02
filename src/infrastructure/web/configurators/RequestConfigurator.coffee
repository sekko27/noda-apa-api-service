bodyParser = require 'body-parser'
compression = require 'compression'

module.exports = ->
  (app) ->
    app.use bodyParser.urlencoded extended: true
    app.use bodyParser.json()
