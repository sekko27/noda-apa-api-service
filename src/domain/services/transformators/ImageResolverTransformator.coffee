class ImageResolverTransformator
  #Inject imageService
  transform: (model, callback) ->
    @imageService.findOrCreate(model, callback)

module.exports = ImageResolverTransformator
