BaseModelService = require './BaseModelService'

class ForumService extends BaseModelService

    constructor: () ->

        super Forum, 
            oneToManyModelClasses: [Topic]

module.exports = new ForumService()