ContextExtractor = require './ContextExtractor'
SimpleExtractor = require './SimpleExtractor'
ArrayExtractor = require './ArrayExtractor'

module.exports = ->
  imageExtractor = (path) ->
    new ContextExtractor path, [
      {
        name: 'url'
        extractor: new SimpleExtractor 'x:URL'
      }
      {
        name: 'height'
        extractor: new SimpleExtractor 'x:Height'
      }
      {
        name: 'width'
        extractor: new SimpleExtractor 'x:Width'
      }
    ]

  new ContextExtractor '//x:ItemLookupResponse/x:Items/x:Item', [
    {
      name: 'asin'
      extractor: new SimpleExtractor 'x:ASIN'
    }
    {
      name: 'detailPageURL'
      extractor: new SimpleExtractor 'x:DetailPageURL'
    }
    {
      name: 'links'
      extractor: new ArrayExtractor 'x:ItemLinks/x:ItemLink', new ContextExtractor '.', [
        {
          name: 'description'
          extractor: new SimpleExtractor 'x:Description'
        }
        {
          name: 'url'
          extractor: new SimpleExtractor 'x:URL'
        }
      ]
    }
    {
      name: 'smallImage'
      extractor: imageExtractor 'x:SmallImage'
    }
    {
      name: 'mediumImage'
      extractor: imageExtractor 'x:MediumImage'
    }
    {
      name: 'largeImage'
      extractor: imageExtractor 'x:LargeImage'
    }
    {
      name: 'imageSets'
      extractor: new ArrayExtractor 'x:ImageSets/x:ImageSet', new ContextExtractor '.', [
        {
          name: 'swatchImage'
          extractor: imageExtractor 'x:SwatchImage'
        }
        {
          name: 'smallImage'
          extractor: imageExtractor 'x:SmallImage'
        }
        {
          name: 'thumbnailImage'
          extractor: imageExtractor 'x:ThumbnailImage'
        }
        {
          name: 'tinyImage'
          extractor: imageExtractor 'x:TinyImage'
        }
        {
          name: 'mediumImage'
          extractor: imageExtractor 'x:MediumImage'
        }
        {
          name: 'largeImage'
          extractor: imageExtractor 'x:LargeImage'
        }
      ]
    }
    {
      name: 'authors'
      extractor: new ArrayExtractor 'x:ItemAttributes/x:Author', new SimpleExtractor '.'
    }
    {
      name: 'binding'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Binding'
    }
    {
      name: 'ean'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:EAN'
    }
    {
      name: 'isbn'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:ISBN'
    }
    {
      name: 'label'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Label'
    }
    {
      name: 'manufacturer'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Manufacturer'
    }
    {
      name: 'productGroup'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:ProductGroup'
    }
    {
      name: 'productTypeName'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:ProductTypeName'
    }
    {
      name: 'publicationDate'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:PublicationDate'
    }
    {
      name: 'publisher'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Publisher'
    }
    {
      name: 'studio'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Studio'
    }
    {
      name: 'title'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:Title'
    }
  ]