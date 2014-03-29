async = require 'async'

module.exports =

    _config: {}

    findForumTopics: (req, res) ->

        forumId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        ForumService.findOneById(forumId)

        .then (forum) ->

            ForumService.findRelatedObject forum, Topic, skip, limit

        .then (topics) ->

            UserService.findAndAssignToObject topics

        .then (topics) ->

            res.json topics

        .catch (err) ->

            res.json err

        .done()