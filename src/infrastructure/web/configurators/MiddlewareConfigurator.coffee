_ = require 'lodash'

module.exports = (middlewares) ->
  (app) ->
    _.each middlewares, (middleware) ->
      app.use middleware