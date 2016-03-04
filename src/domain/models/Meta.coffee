module.exports = (driver, connection, Link, ImageSet) ->
  editorialReviewSchema = ->
    source:
      type: String
      required: true
    content:
      type: String
      required: true
    isLinkSuppressed:
      type: Boolean
      default: false

  similarProductSchema = ->
    asin:
      type: String
      required: true
    title:
      type: String
      required: false

  dateSchema = ->
    year:
      type: Number
      default: 0
      index: true
      required: false
    month:
      type: Number
      default: 0
      required: false
    day:
      type: Number
      default: 0
      required: false

  languageSchema = ->
    name:
      type: String
      index: true
      required: true
    type:
      type: String
      required: true

  dimensionSchema = ->
    value:
      type: Number
      default: 0
    unit:
      type: String
      default: 'unknown'

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
    publicationDate: dateSchema()
    releaseDate: dateSchema()
    languages: [languageSchema()]
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
    isAdultProduct:
      type: Boolean
      required: false
      index: true
      default: false
    isEligibleForTradeIn:
      type: Boolean
      required: false
      index: true
      default: false
    numberOfPages:
      type: Number
      required: false
      index: true
      default: 0
    itemDimension:
      height: dimensionSchema()
      width: dimensionSchema()
      weight: dimensionSchema()
      length: dimensionSchema()
    mpn:
      type: String
      required: false
    editorialReviews: [editorialReviewSchema()]

    nodes: [
      type: driver.Schema.Types.ObjectId
      ref: 'BrowseNode'
    ]

    similarProducts: [similarProductSchema()]

  connection.model('Meta', schema)