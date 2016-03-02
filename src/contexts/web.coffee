Helper = require('wire-context-helper').Helper()

module.exports =
  webExpress:
    create:
      module: 'express'
      args: []

  webApp:
    sub:
      module: 'helper#beans.ConfigurableFactory'
      args: [
        Helper.ref 'webExpress'
        Helper.refs [
          'applicationLogConfigurator'
          'applicationCompressionConfigurator'
          'applicationRequestConfigurator'
          'applicationMiddlewareConfigurator'
          'applicationRouterConfigurator'
          'applicationErrorLogConfigurator'
        ]
      ]

  applicationLogConfigurator:
    create:
      module: Helper.ApplicationConfigurator('Log')
      args: [
        Helper.ref 'logger'
        {
          expressFormat: false
          meta: false
          msg: "express.log - {{res.statusCode}} - {{req.ip}} - {{req.headers['user-agent']}} - {{req.method}} - {{res.responseTime}}ms - {{req.url}} "
        }
      ]

  applicationCompressionConfigurator:
    create:
      module: Helper.ApplicationConfigurator('Compression')
      args: []

  applicationRequestConfigurator:
    create:
      module: Helper.ApplicationConfigurator('Request')
      args: []

  applicationMiddlewareConfigurator:
    create:
      module: Helper.ApplicationConfigurator('Middleware')
      args: Helper.refs [
        'responseMiddleware', 'requestMiddleware'
      ]

  applicationRouterConfigurator:
    create:
      module: Helper.ApplicationConfigurator('Router')
      args: Helper.refs [ 'controllerContainer']

  applicationErrorLogConfigurator:
    create:
      module: Helper.ApplicationConfigurator('ErrorLog')
      args: Helper.refs ['logger']

  responseMiddleware:
    create:
      module: Helper.ApplicationMiddleware('Response')
      args: Helper.refs ['logger']

  requestMiddleware:
    create:
      module: Helper.ApplicationMiddleware('Request')
      args: Helper.refs ['logger']

  controllerContainer:
    create:
      module: Helper.controller('ControllerContainer')
      args: [
        {
          meta: Helper.ref 'metaController'
        }
      ]

  metaController:
    create:
      module: Helper.Controller('Meta')
    properties:
      service: Helper.ref 'apaProxyService'
      logger: Helper.ref 'logger'