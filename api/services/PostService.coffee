BaseModelService = require './BaseModelService'

class PostService extends BaseModelService

    constructor: () ->

        super Topic, 
            manyToOneModelClasses: [User, Topic]

module.exports = new PostService()