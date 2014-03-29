ModelHelper = require './ModelHelper'

module.exports = 

    findAndAssignUser: (userRelatedObjects, asyncCallback) ->

        ModelHelper.findAndAssignManyToOneRelatedObject userRelatedObjects, User, 'userId', 'user', asyncCallback