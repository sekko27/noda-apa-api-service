ew = require 'express-winston'

module.exports = (logger) ->
  (app) ->
    app.use ew.errorLogger
      winstonInstance: logger
