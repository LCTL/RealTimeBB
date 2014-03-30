module.exports = 

    _config: {}

    create: (req, res) ->

        topicId = req.param 'topicId'
        content = req.param 'content'
        user = req.session.user

        TopicService.findOneById(topicId)

        .then (topic) ->

            Utils.promiseTask null, (deferred) ->

                if topic

                    Post.create

                        topicId: topicId
                        userId: user.id
                        content: content
                        isHead: false

                    .then (post) ->

                        deferred.resolve post

                    .fail (err) ->

                        deferred.reject err

                else

                    deferred.reject

                        status: 500
                        message: "Topic not found"

        .then (post) ->

            PostService.findAndAssignManyToOneRelatedObject post, User

        .then (post) ->

            res.json post

        .catch (err) ->

            console.dir err

            res.json err

        .done()