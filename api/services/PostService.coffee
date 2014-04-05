BaseModelService = require './BaseModelService'

class PostService extends BaseModelService

    constructor: () ->

        super Post, 
            manyToOneModelClasses: [User, Topic]

module.exports = new PostService()