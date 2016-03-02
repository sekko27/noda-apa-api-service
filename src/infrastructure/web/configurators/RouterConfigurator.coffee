_ = require 'lodash'

module.exports = (controllers) ->
  (app) ->
    action = (controller, action) ->
      controllers.action controller, action

    #####################
    # Login
    app.get '/meta/:asin/xml', action('meta', 'xml')
    app.get '/meta/:asin/json', action('meta', 'json')
    app.get '/meta/count', action('meta', 'count')
