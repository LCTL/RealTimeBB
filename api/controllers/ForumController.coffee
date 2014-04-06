async = require 'async'
Q = require 'q'

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

    create: (req, res) ->

        Forum.create(req.params.all()).done (err, forum) ->

            ForumService.publishCreate forum
            res.json forum

    update: (req, res) ->

        forumId = req.param 'id'

        Forum.update id: forumId, req.params.all()

        , (err, forum) ->

            if err

                res.json err 

            else if forum

                ForumService.publishUpdate forum

                res.json forum 

    destroy: (req, res) ->

        forumId = req.param 'id'

        ForumService.findOneById(forumId)

        .then (forum) ->

            if forum

                forum.destroy (err) ->

                    if err

                        res.json err 

                    else 

                        ForumService.publishDestroy forum

                        res.json forum 

    findForumTopics: (req, res) ->

        forumId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        ForumService.findOneById(forumId)

        .then (forum) ->

            Utils.promiseTask null, (deferred) ->

                if forum

                    findOptions = 
                        skip: skip 
                        limit: limit
                        sort: 'updatedAt DESC'

                    ForumService.findOneToManyRelatedObject(forum, Topic, findOptions)

                    .then (topics) ->

                        deferred.resolve topics

                    .fail (err) ->

                        deferred.reject []

                else

                    deferred.reject []

        .then (topics) ->

            findOptions = 
                where:
                    isHead: true

            Q.all [
                TopicService.findAllAndAssignManyToOneRelatedObject(topics),
                TopicService.findAndAssignOneToManyRelatedObject(topics, Post, findOptions)
                TopicService.findAndAssignLastPost(topics)
            ]

        .then (arrayOfTopics) ->

            res.json arrayOfTopics[0]

        .catch (err) ->

            res.json err

        .done()