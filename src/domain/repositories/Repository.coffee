class Repository
  constructor: (@model) ->

  findOne: (args...) ->
    @model.findOne args...

  find: (args...) ->
    @model.find args...

  findById: (id, args...) ->
    @model.findById id, args...

  count: (args...) ->
    @model.count args...

  remove: (args...) ->
    @model.remove args...

  removeById: (id, args...) ->
    @model.remove _id: id, args...

  create: (doc, callback) ->
    @model.create doc, callback

  update: (args...) ->
    @model.update args...

  findOneAndUpdate: (args...) ->
    @model.findOneAndUpdate args...

  newInstance: (doc) ->
    new @model doc

module.exports = Repository

