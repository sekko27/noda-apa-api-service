_ = require 'lodash'
ContextExtractor = require './ContextExtractor'
SimpleExtractor = require './SimpleExtractor'
ArrayExtractor = require './ArrayExtractor'
BrowseNodeExtractor = require './BrowseNodeExtractor'
ImageResolverTransformator = require './ImageResolverTransformator'
DimensionExtractor = require './DimensionExtractor'

module.exports = (imageTransformator, browseNodeTransformator) ->
  booleanTransformator = transform: (value, cb) ->
    setImmediate(->cb(null, value == '1'))

  integerTransformator = (def) ->
    transform: (value, cb) ->
      integer = parseInt(value, 10)
      setImmediate(->cb(null, if isNaN(integer) then def else Math.floor(integer)))

  dateTransformator = transform: (value, cb) ->
    return setImmediate(->cb(null, null)) if not _.isString(value)
    [y, m, d] = value.split('-')
    setImmediate -> cb null,
      year: y ? 0
      month: m ? 0
      day: d ? 0

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
    ], imageTransformator

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
      extractor: new SimpleExtractor 'x:ItemAttributes/x:PublicationDate', null, dateTransformator
    }
    {
      name: 'releaseDate'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:ReleaseDate', null, dateTransformator
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
    {
      name: 'nodes'
      extractor: new ArrayExtractor 'x:BrowseNodes/x:BrowseNode', new BrowseNodeExtractor(), browseNodeTransformator
    }
    {
      name: 'isAdultProduct'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:IsAdultProduct', '0', booleanTransformator
    }
    {
      name: 'isEligibleForTradeIn'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:IsEligibleForTradeIn', '0', booleanTransformator
    }
    {
      name: 'numberOfPages'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:NumberOfPages', 0, integerTransformator(0)
    }
    {
      name: 'languages'
      extractor: new ArrayExtractor 'x:ItemAttributes/x:Languages/x:Language', new ContextExtractor '.', [
        {
          name: 'name'
          extractor: new SimpleExtractor 'x:Name'
        }
        {
          name: 'type'
          extractor: new SimpleExtractor 'x:Type'
        }
      ]
    }
    {
      name: 'itemDimension'
      extractor: new ContextExtractor 'x:ItemAttributes/x:ItemDimensions', [
        {
          name: 'width'
          extractor: new DimensionExtractor 'x:Width'
        }
        {
          name: 'height'
          extractor: new DimensionExtractor 'x:Height'
        }
        {
          name: 'weight'
          extractor: new DimensionExtractor 'x:Weight'
        }
        {
          name: 'length'
          extractor: new DimensionExtractor 'x:Length'
        }
      ]
    }
    {
      name: 'mpn'
      extractor: new SimpleExtractor 'x:ItemAttributes/x:MPN'
    }
    {
      name: 'editorialReviews'
      extractor: new ArrayExtractor 'x:EditorialReviews/x:EditorialReview', new ContextExtractor '.', [
        {
          name: 'source'
          extractor: new SimpleExtractor 'x:Source'
        }
        {
          name: 'content'
          extractor: new SimpleExtractor 'x:Content'
        }
        {
          name: 'isLinkSuppressed'
          extractor: new SimpleExtractor 'x:IsLinkSuppressed', '0', booleanTransformator
        }
      ]
    }
    {
      name: 'similarProducts'
      extractor: new ArrayExtractor 'x:SimilarProducts/x:SimilarProduct', new ContextExtractor '.', [
        {
          name: 'asin'
          extractor: new SimpleExtractor 'x:ASIN'
        }
        {
          name: 'title'
          extractor: new SimpleExtractor 'x:Title'
        }
      ]
    }
  ]