_ = require 'lodash'
async = require 'async'

class BrowseNodeTransformator
  #Inject browseNodeService
  #Inject logger
  transform: (value, callback) ->
    async.mapSeries(
      value,
      (browseNode, cb) =>
        if browseNode.parents and _.isArray(browseNode.parents) and not _.isEmpty(browseNode.parents)
          return setImmediate(->cb("Parent mismatch")) if browseNode.parent != browseNode.parents[0].id
          @transform browseNode.parents, (err, parentIds) =>
            return setImmediate(->cb(err)) if err
            return setImmediate(->cb("No first parent")) if not parentIds?[0]
            bn =
              id: browseNode.id
              name: browseNode.name
              category: browseNode.category
              parent: parentIds?[0]
            console.log '0', bn
            @browseNodeService.findOrCreate bn, (err, instance) ->
              setImmediate(->cb(err, instance?._id))
        else
          console.log '1', browseNode
          @browseNodeService.findOrCreate browseNode, (err, instance) ->
            setImmediate(->cb(err, instance?._id))
      callback
    )
module.exports = BrowseNodeTransformator