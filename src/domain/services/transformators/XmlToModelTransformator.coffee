XML = require 'libxmljs'
concat = require 'concat-stream'

class XmlToModelTransformator
  #Inject extractor
  #Inject logger

  convertStream: (xmlStream, callback) ->
    xmlStream.on 'error', callback
    xmlStream.pipe concat encoding: 'string', (result) =>
      @convertXml(result, callback)

  convertXml: (xml, callback) ->
    document = XML.parseXml xml
    @extractor.run document, callback

module.exports = XmlToModelTransformator
