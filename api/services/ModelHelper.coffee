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

findAllModel = (model, skip, limit, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        model.find()

        .skip(skip)

        .limit(limit)

        .then (models) ->

            deferred.resolve models

        .fail (err) ->

            deferred.reject err

findModelById = (model, ids, asyncCallback) ->

    _findModelById model, ids, 'find', asyncCallback

findOneModelById = (model, ids, asyncCallback) ->

    _findModelById model, ids, 'findOne', asyncCallback

findOneToManyRelatedObject = (objects, relatedObjectModel, relatedObjectIdFieldName, skip, limit, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        objects = Utils.toArray objects

        objectIds = (object.id for object in objects when object and object.id)

        whereClause = {}
        whereClause[relatedObjectIdFieldName] = objectIds

        relatedObjectModel.find()
        .where(whereClause)
        .skip(skip)
        .limit(limit)
        .then (relatedObjects) ->

            deferred.resolve relatedObjects

        .fail (err) ->

            deferred.reject err

findManyToOneRelatedObject = (objects, relatedObjectModel, relatedObjectIdFieldName, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        objects = Utils.toArray objects

        async.waterfall [

            (callback) ->

                groupCollection objects, relatedObjectIdFieldName, (err, objectMap) ->

                    callback err, objectMap

            , (objectMap, callback) ->

                relatedObjectIds = (key for key, value of objectMap)

                findModelById relatedObjectModel, relatedObjectIds, (err, relatedObjects) ->

                    callback err, relatedObjects

        ], (err, results) ->

            if err then deferred.reject err else deferred.resolve results

findAndAssignOneToManyRelatedObject = (objects, relatedObjectModel, relatedObjectIdFieldName, relatedObjectFieldName, skip, limit, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        findOneToManyRelatedObject object, relatedObjectModel, relatedObjectIdFieldName, skip, limit, (err, relatedObjects) ->

            if err 

                deferred.reject objects

                return

            groupCollection relatedObjects, relatedObjectIdFieldName, (err, relatedObjectMap) ->

                if relatedObjectMap

                    for object in objects

                        if relatedObjectMap[object.id] 

                            object[relatedObjectFieldName] = relatedObjectMap[object.id]

                        else 

                            object[relatedObjectFieldName] = []

                deferred.resolve objects

findAndAssignManyToOneRelatedObject = (objects, relatedObjectModel, relatedObjectIdFieldName, relatedObjectFieldName, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        groupCollection objects, relatedObjectIdFieldName, (err, objectMap) ->

            findManyToOneRelatedObject objects, relatedObjectModel, relatedObjectIdFieldName, (err, relatedObjects) ->

                if relatedObjects

                    fieldName = relatedObjectModel

                    for relatedObject in relatedObjects

                        for object in objectMap[relatedObject.id]

                            object[relatedObjectFieldName] = relatedObject

                deferred.resolve objects

module.exports = 

    groupCollection: groupCollection

    findAllModel: findAllModel

    findModelById: findModelById

    findOneModelById: findOneModelById

    findOneToManyRelatedObject: findOneToManyRelatedObject

    findManyToOneRelatedObject: findManyToOneRelatedObject

    findAndAssignOneToManyRelatedObject: findAndAssignOneToManyRelatedObject

    findAndAssignManyToOneRelatedObject: findAndAssignManyToOneRelatedObject
