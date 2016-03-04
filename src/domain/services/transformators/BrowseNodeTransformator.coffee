_ = require 'lodash'
async = require 'async'

class BrowseNodeTransformator
  #Inject browseNodeService
  #Inject logger
  transform: (value, callback) ->
    async.mapSeries(
      value
      (branch, cb) =>
        @transformBranch branch, (err, branchNodes) ->
          return setImmediate(->cb(err)) if err
          return setImmediate(->cb("No branch result")) if not _.isArray(branchNodes)
          setImmediate(->cb(null, _.last(branchNodes)?._id))
      callback
    )

  transformBranch: (branch, callback) ->
    async.mapSeries(
      branch
      (node, cb) =>
        @resolveParent node, (err, parentId) =>
          return setImmediate(->cb(err)) if err
          doc = id: node.id, category: node.category, name: node.name, parent: parentId
          @browseNodeService.findOrCreate doc, cb
      callback
    )

  resolveParent: (node, callback) ->
    parentId = node.parent ? null
    return setImmediate(->callback(null, null)) if parentId == null
    @browseNodeService.findByHumanId parentId, (err, result) ->
      setImmediate(->callback(err, result?._id))

module.exports = BrowseNodeTransformator