define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Forum', ['$injector', '$rootScope', 'ResourceFactory', 'CommunicationService', ($injector, $rootScope, resourceFactory, communicationService) ->

        communicationService.listenEvent 'Forum'
        communicationService.listenEvent 'Topic'

        basePath = '/forum'

        resourceFactory 'Forum', basePath, 

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