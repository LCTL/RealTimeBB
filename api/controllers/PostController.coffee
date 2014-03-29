module.exports = 

    _config: {}

    topicPost: (req, res) ->

        topicId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        async.waterfall [

            (callback) ->

                TopicService.findOneById topicId, (err, topic) ->

                    callback err, topic

            , (topic, callback) ->

                TopicService.findTopicRelatedObject forum, Post, skip, limit, (err, topics) ->

                    callback err, topics

            , (topics, callback) ->

                UserService.findAndAssignUser topics, (err, topics) ->

                    callback err, topics

        ], (err, results) ->

            if err then res.json err else res.json results