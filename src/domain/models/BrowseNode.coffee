module.exports = (driver, connection) ->
  schema = new driver.Schema
    id:
      type: Number
      required: true
      index:
        unique: true
    name:
      type: String
      required: true
    category:
      type: Boolean
      default: false
    parent:
      type: driver.Schema.Types.ObjectId

  connection.model('BrowseNode', schema)
