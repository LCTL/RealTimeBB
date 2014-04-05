define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Forum', ['$injector', '$rootScope', 'ResourceFactory', 'CommunicationService', ($injector, $rootScope, resourceFactory, communicationService) ->

        communicationService.listenEvent 'Topic'

        basePath = '/forum'

        resourceFactory basePath, 

            relatedModels: 
                Topic: ['topics']

            instanceVariables:
                topics: null
                fetchTopicPage: 1
                fetchTopicLimit: 20
                fetchingTopic: false
                allTopicLoaded: false

            instanceMethods: 

                init: () ->

                    @topics = []

                    $rootScope.$on 'Topic', (event, message) =>

                        if message.action is 'create' and @id is message.data.forumId

                            @topics.unshift @convertDataToRelatedModel 'Topic', message.data
                            $rootScope.$apply()

                        else if message.action is 'update' and @id is message.data.forumId

                            async.each @topics

                            , (topic, callback) ->

                                if message.data.id is topic.id

                                    topic.copyPropertyToInstance message.data

                                callback null

                            , (err) =>

                                @reorderTopics()

                        else if message.action is 'destroy' and @id is message.data.forumId

                            async.filter @topics

                            , (item, callback) ->

                                if message.data.id is item.id

                                    callback false

                                else 

                                    callback true

                            , (err, results) ->

                                @topics = results
                                $rootScope.$apply()

                reorderTopics: () ->

                    async.sortBy @topics

                    , (topic, callback) ->

                        callback null, moment(topic.updatedAt).unix() * -1

                    , (err, results) ->

                        @topics = results
                        $rootScope.$apply()

                fetchMoreTopics: () ->

                    if not @fetchingTopic and not @allTopicLoaded

                        @fetchingTopic = true

                        path = "#{basePath}/#{@id}/topics"

                        skip = @constructor.calculateSkipByPage @fetchTopicPage

                        communicationService.get(path, {skip: skip, limit: @fetchTopicLimit}).then (topics) =>

                            if topics and not _.isEmpty topics

                                @loadModelDependency 'Topic', () =>

                                    @topics.push @convertDataToRelatedModel 'Topic', topic for topic in topics

                                    @allTopicLoaded = true if topics.length < @fetchTopicLimit

                                    @fetchTopicPage++

                            else if _.isEmpty topics

                                @allTopicLoaded = true

                            @fetchingTopic = false
    ]