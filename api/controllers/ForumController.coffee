async = require 'async'

module.exports =

    _config: {}

    find: (req, res) ->

        forumId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        if forumId 

            promise = ForumService.findOneById(forumId)

        else 

            promise = ForumService.findAll
                skip: skip,
                limit: limit

        promise.then (forums) ->

            res.json forums

        .catch (err) ->

            res.json err 

    findForumTopics: (req, res) ->

        forumId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        ForumService.findOneById(forumId)

        .then (forum) ->

            ForumService.findOneToManyRelatedObject forum, Topic, 
                skip: skip 
                limit: limit

        .then (topics) ->

            TopicService.findAndAssignManyToOneRelatedObject topics, User

        .then (topics) ->

            res.json topics

        .catch (err) ->

            res.json err

        .done()