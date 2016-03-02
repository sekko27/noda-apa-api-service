_ = require 'lodash'

class ControllerContainer
  constructor: (controllers, validators = {}) ->
    Object.defineProperty @, 'controllers', get: -> controllers
    Object.defineProperty @, 'validators', get: -> validators

  validate: (name) ->
    throw "Validator not found: #{name}" if not _.has(@validators, name)
    @validators[name].validate

  controller: (name) ->
    throw "Controller not found: '#{name}'" if not _.has(@controllers, name)
    @controllers[name]

  action: (controllerName, action) ->
    controller = @controller(controllerName)
    throw "Controller action not found: #{controllerName}.#{action}" if not _.isFunction(controller[action])
    _.bind(controller[action], controller)

module.exports = ControllerContainer
