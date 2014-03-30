BaseModelService = require './BaseModelService'
Utils = require './Utils'
async = require 'async'

class TopicService extends BaseModelService

    constructor: () ->

        super Topic, 
            manyToOneModelClasses: [User, Forum]
            oneToManyModelClasses: [Post]

    findAndAssignHeadPost: (topics, asyncCallback) ->

        Utils.promiseTask asyncCallback, (deferred) =>

            findOptions = 
                where:
                    isHead: true

            fieldName = 'headPost'

            @ModelHelper.findAndAssignOneToManyRelatedObject(topics, Post, @modelRelatedObjectIdentity, fieldName, findOptions)

            .then (topics) ->

                headPostArrayToSingleObject = (topic, callback) ->
                    
                    if topic[fieldName].length == 0

                        topic[fieldName] = null 

                    else if topic[fieldName].length >= 1

                        topic[fieldName] = topic[fieldName][0] 
                    
                    callback null

                if Utils.isArray topics

                    async.each topics, headPostArrayToSingleObject, (err) ->

                        if err then deferred.reject err else deferred.resolve topics

                else 

                    headPostArrayToSingleObject topics, () ->

                        deferred.resolve topics

            .fail (err) ->

                deferred.reject err

module.exports = new TopicService()