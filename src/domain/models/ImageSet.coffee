module.exports = (driver, connection) ->
  schema = new driver.Schema
    smallImage:
      type: driver.Schema.Types.ObjectId
      ref: 'Image'
      required: false
    thumbnailImage:
      type: driver.Schema.Types.ObjectId
      ref: 'Image'
      required: false
    tinyImage:
      type: driver.Schema.Types.ObjectId
      ref: 'Image'
      required: false
    mediumImage:
      type: driver.Schema.Types.ObjectId
      ref: 'Image'
      required: false
    largeImage:
      type: driver.Schema.Types.ObjectId
      ref: 'Image'
      required: false

  connection.model('ImageSet', schema)
