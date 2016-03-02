_ = require 'lodash'

module.exports = (logger) ->
  (req, res, next) ->
    integer = (name, raw, def, options) ->
      value = parseInt raw, (options?['radix'] ? 10)
      intValue =
        if isNaN(value)
          logger.warn "Invalid integer request parameter: #{name} = #{raw}"
          def
        else
          value
      min = options?.min ? Number.NEGATIVE_INFINITY
      max = options?.max ? Number.POSITIVE_INFINITY
      if min <= intValue <= max
        intValue
      else
        logger.warn "Integer request parameter out of range (#{name}): #{min} <= #{intValue} <= #{max}"
        def

    mixin =
      integerParam: (name, def, options) ->
        integer(name, req.param(name, def), def, options)
      integerBody: (name, def, options) ->
        integer(name, req.body?[name], def, options)
      userId: ->
        req.user._id
      strict: (container, filter) ->
        keys = _.intersection _.keys(container), filter
        _.zipObject keys, _.map keys, (key) ->container[key]
      strictBody: (filter) ->
        mixin.strict req.body, filter
      strictParams: (filter) ->
        mixin.strict req.params, filter
      strictQueries: (filter) ->
        mixin.strict req.query, filter
      queryDimension: (key, min, max, def) ->
        int = parseInt(req.query[key])
        if not (min <= int <= max)
          int = def
        int

    _.merge req, mixin
    next()

