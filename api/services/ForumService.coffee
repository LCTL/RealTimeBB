ModelHelper = require './ModelHelper'
Utils = require './Utils'

findById = (id, method, asyncCallback) ->

    Utils.promiseTask asyncCallback, (deferred) ->

        Forum[method]()

        .where

            id: id

        .then (forum) ->

            deferred.resolve forum

        .fail (err) ->

            deferred.reject err

module.exports = 

    findOneById: (id, asyncCallback) ->

        findById id, 'findOne', asyncCallback

    findById: (ids, asyncCallback) ->

        findById ids, 'find', asyncCallback

    findAndAssignForum: (forumRelatedObjects, asyncCallback) ->

        ModelHelper.findAndAssignManyToOneRelatedObject forumRelatedObjects, Forum, 'forumId', 'forum', asyncCallback

    findForumRelatedObject: (forums, model, skip, limit, asyncCallback) ->

        ModelHelper.findOneToManyRelatedObject forums, model, 'forumId', skip, limit, asyncCallback

    findAndAssignForumRelatedObject: (forums, model, skip, limit, asyncCallback) ->

        ModelHelper.findAndAssignOneToManyRelatedObject forums, model, 'forumId', model.identity, skip, limit, asyncCallback