ModelHelper = require './ModelHelper'
Utils = require './Utils'

module.exports = 

    findOneById: (id, asyncCallback) ->

        ModelHelper.findOneModelById Forum, id, asyncCallback

    findById: (ids, asyncCallback) ->

        ModelHelper.findModelById Forum, id, asyncCallback

    findAndAssignForum: (forumRelatedObjects, asyncCallback) ->

        ModelHelper.findAndAssignManyToOneRelatedObject forumRelatedObjects, Forum, 'forumId', 'forum', asyncCallback

    findForumRelatedObject: (forums, model, skip, limit, asyncCallback) ->

        ModelHelper.findOneToManyRelatedObject forums, model, 'forumId', skip, limit, asyncCallback

    findAndAssignForumRelatedObject: (forums, model, skip, limit, asyncCallback) ->

        ModelHelper.findAndAssignOneToManyRelatedObject forums, model, 'forumId', model.identity, skip, limit, asyncCallback