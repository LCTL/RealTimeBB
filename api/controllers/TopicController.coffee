Q = require 'q'

module.exports = 

    _config: {}

    find: (req, res) ->

        topicId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        if topicId 

            promise = TopicService.findOneById(topicId)

        else 

            promise = TopicService.findAll 
                skip: skip,
                limit: limit

        promise.then (topic) ->

            TopicService.findAllAndAssignManyToOneRelatedObject topic

        .then (topic) ->

            res.json topic

        .catch (err) ->

            res.json err 

    create: (req, res) ->

        forumId = req.param 'forumId'
        title = req.param 'title'
        content = req.param 'content'
        user = req.session.user

        ForumService.findOneById(forumId)

        .then (forum) ->

            Utils.promiseTask null, (deferred) ->

                if forum

                    Topic.create

                        forumId: forumId
                        userId: user.id 
                        title: title

                    .then (topic) ->

                        deferred.resolve topic

                    .fail (err) ->

                        deferred.reject err

                else

                    deferred.reject

                        status: 500
                        message: "Forum not found"

        .then (topic) ->

            Utils.promiseTask null, (deferred) ->

                Post.create
                    topicId: topic.id 
                    userId: user.id 
                    content: content

                .then (post) ->

                    topic.post = post
                    deferred.resolve topic

                .fail (err) ->

                    deferred.reject err

        .then (topic) ->

            res.json topic

        .catch (err) ->

            res.json err

        .done()

    findTopicPosts: (req, res) ->

        topicId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        TopicService.findOneById(topicId)

        .then (topic) ->

            TopicService.findAndAssignOneToManyRelatedObject topic, Post, skip, limit

        .then (posts) ->

            TopicService.findAndAssignManyToOneRelatedObject posts, User

        .then (posts) ->

            res.json posts

        .catch (err) ->

            res.json err

        .done()