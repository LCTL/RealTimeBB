ModelHelper = require './ModelHelper'

module.exports = 

    class BaseModelService

        constructor: (@modelClass, @modelRelatedObjectIdentity) ->

            @limit = 20

            @modelName = @modelClass.identity
            @modelRelatedObjectIdentity = @modelName + 'Id' if not @modelRelatedObjectIdentity

            @ModelHelper = ModelHelper

        findAll: (skip, limit, asyncCallback) ->

            limit ?= @limit

            @ModelHelper.findAllModel @modelClass, skip, limit, asyncCallback

        findOneById: (id, asyncCallback) ->

            @ModelHelper.findOneModelById @modelClass, id, asyncCallback

        findById: (ids, asyncCallback) ->

            @ModelHelper.findModelById @modelClass, id, asyncCallback

        findAndAssignToObject: (modelObjects, asyncCallback) ->

            @ModelHelper.findAndAssignManyToOneRelatedObject modelObjects, @modelClass, @modelRelatedObjectIdentity, @modelName, asyncCallback

        findRelatedObject: (modelObjects, targetModelClass, skip, limit, asyncCallback) ->

            limit ?= @limit

            @ModelHelper.findOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, skip, limit, asyncCallback

        findAndAssignRelatedObject: (modelObjects, targetModelClass, skip, limit, asyncCallback) ->

            @ModelHelper.findAndAssignOneToManyRelatedObject modelObjects, targetModelClass, @modelRelatedObjectIdentity, @modelName, skip, limit, asyncCallback