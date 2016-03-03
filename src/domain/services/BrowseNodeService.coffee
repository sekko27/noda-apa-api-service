class BrowseNodeService
  findOrCreate: (node, callback) ->
    return setImmediate(->callback("No browse node id has been specified")) if not node?.id
    @repository.findOne id: node.id, (err, result) =>
      return setImmediate(->callback(err)) if err
      return @repository.create(node, callback) if not result
      setImmediate(->callback(null, result))

module.exports = BrowseNodeService