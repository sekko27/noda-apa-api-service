class ImageService
  findOrCreate: (image, callback) ->
    return setImmediate(->callback("No url has been specified")) if not image?.url
    @repository.findOne url: image.url, (err, result) =>
      return setImmediate(->callback(err)) if err
      return @repository.create(image, callback) if not result
      setImmediate(->callback(null, result))

module.exports = ImageService