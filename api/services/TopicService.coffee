Q = require 'q'
Utils = require './Utils'
BaseModelService = require './BaseModelService'

class TopicService extends BaseModelService

    constructor: () ->

        super Topic

    findAndAssignAllRelatedObject: (topics) ->

        Utils.promiseTask null, (deferred) ->

            Q.all([

                ForumService.findAndAssignToObject topics
                UserService.findAndAssignToObject topics

            ]).then (results) ->

                deferred.resolve results[0]

            .fail (err) ->

                deferred.reject err

module.exports = new TopicService()