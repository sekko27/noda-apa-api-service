_ = require 'lodash'

module.exports = _.assign(
  require './base'
  require './log'
  require './persistence'
  require './models'
  require './amazon'
  require './services'
  require './models'
  require './repositories'
  require './web'
)