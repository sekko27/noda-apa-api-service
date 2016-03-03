module.exports = (driver, connection) ->
  schema = new driver.Schema
    url:
      type: String
      required: true
      index:
        unique: true
    width:
      type: Number
      default: 0
    height:
      type: Number
      default: 0

  connection.model('Image', schema)
