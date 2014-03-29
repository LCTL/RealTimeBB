async = require 'async'

module.exports =

    _config: {}

    forumTopic: (req, res) ->

        forumId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        async.waterfall [

            (callback) ->

                ForumService.findOneById forumId, (err, forum) ->

                    callback err, forum

            , (forum, callback) ->

                ForumService.findRelatedObject forum, Topic, skip, limit, (err, topics) ->

                    callback err, topics

            , (topics, callback) ->

                UserService.findAndAssignToObject topics, (err, topics) ->

                    callback err, topics

        ], (err, results) ->

            if err then res.json err else res.json results