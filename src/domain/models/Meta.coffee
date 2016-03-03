module.exports = (driver, connection, Link, ImageSet) ->
  schema = new driver.Schema
    asin:
      type: String
      required: true
      index:
        unique: true

    detailPageURL:
      type: String
      required: false

    links: [Link]
    # Images references into the gridfs files
    # Where meta contains the additional information (width, height)
    smallImage:
      type: driver.Schema.Types.ObjectId
      required: false
    mediumImage:
      type: driver.Schema.Types.ObjectId
      required: false
    largeImage:
      type: driver.Schema.Types.ObjectId
      required: false
    imageSets: [ImageSet]
    authors: [String]
    binding:
      type: String
      required: false
      index: true
    ean:
      type: String
      required: false
      index: true
    isbn:
      type: String
      required: false
      index: true
    label:
      type: String
      required: false
      index: true
    manufacturer:
      type: String
      required: false
      index: true
    productGroup:
      type: String
      required: false
      index: true
    productTypeName:
      type: String
      required: false
      index: true
    publicationDate:
      type: Date
      required: false
      index: true
    publisher:
      type: String
      required: false
      index: true
    studio:
      type: String
      required: false
      index: true
    title:
      type: String
      required: true
      index: true

  connection.model('Meta', schema)