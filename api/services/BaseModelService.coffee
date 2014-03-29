ModelHelper = require './ModelHelper'

module.exports = 

    class BaseModelService

        constructor: (@modelClass, @modelRelatedObjectIdentity) ->

            @modelName = @modelClass.identity
            @modelRelatedObjectIdentity = @modelName + 'Id' if not @modelRelatedObjectIdentity

            @ModelHelper = ModelHelper

        findOneById: (id, asyncCallback) ->

            @ModelHelper.findOneModelById @modelClass, id, asyncCallback

        findById: (ids, asyncCallback) ->

            @ModelHelper.findModelById @modelClass, id, asyncCallback

        findAndAssignToObject: (modelObjects, asyncCallback) ->

            @ModelHelper.findAndAssignManyToOneRelatedObject modelObjects, @modelClass, @modelRelatedObjectIdentity, @modelName, asyncCallback

        findRelatedObject: (modelObjects, targetModelClass, skip, limit, asyncCallback) ->

            @ModelHelper.findOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, skip, limit, asyncCallback

        findAndAssignRelatedObject: (modelObjects, targetModelClass, skip, limit, asyncCallback) ->

            @ModelHelper.findAndAssignOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, @modelName, skip, limit, asyncCallback