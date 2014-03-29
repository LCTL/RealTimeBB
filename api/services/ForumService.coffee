BaseModelService = require './BaseModelService'

class ForumService extends BaseModelService

    constructor: () ->

        super Forum

module.exports = new ForumService()