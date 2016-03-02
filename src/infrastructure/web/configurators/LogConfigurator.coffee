_ = require 'lodash'
ew = require 'express-winston'

BASE_OPTIONS =
  meta: true
  expressFormat: true
  colorStatus: false

module.exports = (logger, options = {}) ->
  (app) ->
    loggerOptions = _.extend {}, BASE_OPTIONS, options, winstonInstance: logger
    app.use ew.logger loggerOptions

