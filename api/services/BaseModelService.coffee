Q = require 'q'
ModelHelper = require './ModelHelper'
Utils = require './Utils'
NotificationService = require './NotificationService'

module.exports = 

    class BaseModelService

        constructor: (@modelClass, options) ->

            @limit = 20

            {@modelRelatedObjectIdentity, @manyToOneModelClasses, @oneToManyModelClasses} = options if options

            @modelName = @modelClass.identity
            @modelRelatedObjectIdentity ?= @createRelationshipIdFieldName(modelClass)
            @manyToOneModelClasses ?= []
            @oneToManyModelClasses ?= []

            @ModelHelper = ModelHelper

        createRelationshipIdFieldName: (modelClass) ->

            modelClass.identity + 'Id'

        createArrayOfObjectFieldName: (modelClass) ->

            modelName = modelClass.identity

            if modelName.slice(-1) is 'y' then modelName.substring(0, modelName.length - 2) + 'ies' else modelName + 's'

        findAll: (findOptions, asyncCallback) ->

            findOptions ?= {}

            findOptions.limit = @limit if not findOptions.limit

            @ModelHelper.findAllModel @modelClass, findOptions, asyncCallback

        countAll: (findOptions, asyncCallback) ->

            @ModelHelper.countAllModel @modelClass, findOptions, asyncCallback

        findOneById: (id, asyncCallback) ->

            @ModelHelper.findOneModelById @modelClass, id, asyncCallback

        findById: (ids, asyncCallback) ->

            @ModelHelper.findModelById @modelClass, id, asyncCallback

        findManyToOneRelatedObject: (modelObjects, targetModelClass, asyncCallback) ->

            @ModelHelper.findManyToOneRelatedObject modelObjects, targetModelClass, @createRelationshipIdFieldName(targetModelClass), asyncCallback

        findAndAssignManyToOneRelatedObject: (modelObjects, targetModelClass, asyncCallback) ->

            fieldName = @createRelationshipIdFieldName targetModelClass

            @ModelHelper.findAndAssignManyToOneRelatedObject modelObjects, targetModelClass, fieldName, targetModelClass.identity, asyncCallback

        findAllAndAssignManyToOneRelatedObject: (modelObjects, asyncCallback) ->

            Utils.promiseTask asyncCallback, (deferred) =>

                if @manyToOneModelClasses?.length > 0

                    promises = (@findAndAssignManyToOneRelatedObject modelObjects, targetModelClass for targetModelClass in @manyToOneModelClasses)

                    Q.all(promises)

                    .then (results) ->

                        deferred.resolve results[0]

                    .fail (err) ->

                        deferred.reject err

                    .done()

                else

                    deferred.resolve modelObjects

        findOneToManyRelatedObject: (modelObjects, targetModelClass, findOptions, asyncCallback) ->

            findOptions ?= {}

            findOptions.limit = @limit if not findOptions.limit

            @ModelHelper.findOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, findOptions, asyncCallback

        findAndAssignOneToManyRelatedObject: (modelObjects, targetModelClass, findOptions, asyncCallback) ->

            fieldName = @createArrayOfObjectFieldName targetModelClass

            @ModelHelper.findAndAssignOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, fieldName, findOptions, asyncCallback

        findAllAndAssignOneToManyRelatedObject: (modelObjects, findOptions, asyncCallback) ->

            Utils.promiseTask asyncCallback, (deferred) =>

                if @oneToManyModelClasses?.length > 0

                    promises = []

                    for targetModelClass in @oneToManyModelClasses

                        promises.push @findAndAssignOneToManyRelatedObject modelObjects, targetModelClass, findOptions

                    Q.all(promises)

                    .then (results) ->

                        deferred.resolve results[0]

                    .fail (err) ->

                        deferred.reject err

                    .done()

                else

                    deferred.resolve modelObjects

        publishCreate: (model, roomName) ->

            NotificationService.publishCreate @modelClass, model, roomName

        publishUpdate: (model, roomName) ->

            NotificationService.publishUpdate @modelClass, model, roomName

        publishDestroy: (model, roomName) ->

            NotificationService.publishDestroy @modelClass, model, roomName
