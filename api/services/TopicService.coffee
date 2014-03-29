BaseModelService = require './BaseModelService'

class TopicService extends BaseModelService

    constructor: () ->

        super Topic

module.exports = new TopicService()