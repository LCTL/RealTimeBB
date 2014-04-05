module.exports = 

    _config: {}

    create: (req, res) ->

        topicId = req.param 'topicId'
        content = req.param 'content'
        user = req.session.user

        currentTopic = null

        TopicService.findOneById(topicId)

        .then (topic) ->

            Utils.promiseTask null, (deferred) ->

                if topic

                    currentTopic = topic

                    TopicService.findAllAndAssignManyToOneRelatedObject(currentTopic)

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

            currentTopic.updatedAt = new Date()

            currentTopic.save (err) ->

                if not err

                    req.socket.broadcast.to('commons').emit 'Topic', 
                        action: 'update'
                        data: currentTopic.toJSON()


            req.socket.broadcast.to('commons').emit 'Post', 
                action: 'create'
                data: post.toJSON()

            res.json post

        .catch (err) ->

            console.dir err

            res.json err

        .done()