Utils = require './Utils'

_findModelById = (model, ids, method, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        model[method]()

        .where

            id: ids

        .then (models) ->

            deferred.resolve models

        .fail (err) ->

            deferred.reject err

groupCollection = (objects, groupFieldName, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        objects = Utils.toArray objects

        async.reduce objects, {}

        , (objectMap, object, reduceCallback) ->

            key = object[groupFieldName]

            if not objectMap[key]

                objectMap[key] = []

            objectMap[key].push object

            reduceCallback null, objectMap

        , (err, objectMap) ->

            deferred.resolve objectMap

findAllModel = (model, findOptions = {}, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        model.find(findOptions)

        .then (models) ->

            deferred.resolve models

        .fail (err) ->

            deferred.reject err

countAllModel = (model, findOptions  = {}, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        model.count(findOptions)

        .then (models) ->

            deferred.resolve models

        .fail (err) ->

            deferred.reject err

findModelById = (model, ids, asyncCallback) ->

    _findModelById model, ids, 'find', asyncCallback

findOneModelById = (model, ids, asyncCallback) ->

    _findModelById model, ids, 'findOne', asyncCallback

findOneToManyRelatedObject = (objects, relatedObjectModelClass, relatedObjectIdFieldName, findOptions, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        objects = Utils.toArray objects
        findOptions ?= {}
        findOptions[relatedObjectIdFieldName] = (object.id for object in objects when object and object.id)

        findAllModel(relatedObjectModelClass, findOptions)

        .then (relatedObjects) ->

            deferred.resolve relatedObjects

        .fail (err) ->

            deferred.reject err

findManyToOneRelatedObject = (objects, relatedObjectModelClass, relatedObjectIdFieldName, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        objects = Utils.toArray objects

        groupCollection(objects, relatedObjectIdFieldName)

        .then (objectMap) ->

            relatedObjectIds = (key for key, value of objectMap)

            findModelById relatedObjectModelClass, relatedObjectIds

        .then (relatedObjects) ->

            deferred.resolve relatedObjects

        .catch (err) ->

            deferred.reject err

        .done()

findAndAssignOneToManyRelatedObject = (objects, relatedObjectModelClass, relatedObjectIdFieldName, relatedObjectFieldName, findOptions, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        findOneToManyRelatedObject objects, relatedObjectModelClass, relatedObjectIdFieldName, findOptions, (err, relatedObjects) ->

            if err 

                deferred.reject err

                return

            groupCollection relatedObjects, relatedObjectIdFieldName, (err, relatedObjectMap) ->

                if relatedObjectMap

                    for object in objects

                        if relatedObjectMap[object.id] 

                            object[relatedObjectFieldName] = relatedObjectMap[object.id]

                        else 

                            object[relatedObjectFieldName] = []

                deferred.resolve objects

findAndAssignManyToOneRelatedObject = (objects, relatedObjectModelClass, relatedObjectIdFieldName, relatedObjectFieldName, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        groupCollection objects, relatedObjectIdFieldName, (err, objectMap) ->

            findManyToOneRelatedObject objects, relatedObjectModelClass, relatedObjectIdFieldName, (err, relatedObjects) ->

                if relatedObjects?.length > 0

                    for relatedObject in relatedObjects

                        for object in objectMap[relatedObject.id]

                            object[relatedObjectFieldName] = relatedObject

                deferred.resolve objects

module.exports = 

    groupCollection: groupCollection

    findAllModel: findAllModel

    countAllModel: countAllModel

    findModelById: findModelById

    findOneModelById: findOneModelById

    findOneToManyRelatedObject: findOneToManyRelatedObject

    findManyToOneRelatedObject: findManyToOneRelatedObject

    findAndAssignOneToManyRelatedObject: findAndAssignOneToManyRelatedObject

    findAndAssignManyToOneRelatedObject: findAndAssignManyToOneRelatedObject
