Q = require 'q'
Utils = require './Utils'
BaseModelService = require './BaseModelService'

class TopicService extends BaseModelService

    constructor: () ->

        super Topic, 
            manyToOneModelClasses: [User, Forum]
            oneToManyModelClasses: [Post]

module.exports = new TopicService()