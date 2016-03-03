_ = require 'lodash'
XML = require 'libxmljs'
concat = require 'concat-stream'
async = require 'async'

class XmlToModelTransformator
  #Inject extractors
  #Inject logger

  convertStream: (xmlStream, callback) ->
    xmlStream.on 'error', callback
    xmlStream.pipe concat encoding: 'utf-8', (result) =>
      @convertXml(result, callback)

  convertXml: (xml, callback) ->
    document = XML.parseXml xml
    tasks = _.reduce(
      @extractors,
      (memo, current) ->
        memo[current.name] = (cb) -> current.extractor.run(document, cb)
        memo
      {}
    )
    async.parallel tasks, callback

module.exports = XmlToModelTransformator
