async = require 'async';

module.exports =

    _config: {}

    forumTopic: (req, res) ->

        async.waterfall [

            (callback) ->

                Forum.findOne()
                .where
                    id: req.param 'id'
                .then (forum) ->

                    callback null, forum

            , (forum, callback) ->

                Topic.find()
                .where
                    forumId: forum.id
                .skip(req.param 'skip')
                .limit(req.param 'limit')
                .then (topics) ->

                    callback null, topics

            , (topics, callback) ->

                async.waterfall [

                    (innerCallback) ->

                        async.reduce topics, {}

                        , (topicMap, topic, reduceCallback) ->

                            if not topicMap[topic.userId]

                                topicMap[topic.userId] = []

                            topicMap[topic.userId].push topic

                            reduceCallback null, topicMap

                        , (err, topicMap) ->

                            innerCallback null, topicMap

                    , (topicMap, innerCallback) ->

                        userIds = (key for key, value of topicMap)

                        User.find()
                        .where
                            'id': userIds
                        .then (users) ->

                            innerCallback null, topicMap, users

                    , (topicMap, users, innerCallback) ->

                        for user in users

                            for topic in topicMap[user.id] 

                                topic.user = user

                        innerCallback null, topics

                ], (err, topics) ->

                    callback null, topics

        ], (err, results) ->

            if err then res.json err else res.json results
