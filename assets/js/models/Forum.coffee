define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Forum', ['ResourceFactory', 'CommunicationService', (resourceFactory, communicationService) ->

        basePath = '/forum'

        resourceFactory basePath, 

            instanceVariable:
                topics: []
                fetchTopicPage: 1
                fetchTopicLimit: 20
                fetchingTopic: false

            instanceProperties: 

                fetchMoreTopics: () ->

                    if not @fetchingTopic

                        @fetchingTopic = true

                        path = "#{basePath}/#{@id}/topics"

                        skip = @constructor.calculateSkipByPage @fetchTopicPage

                        communicationService.get(path, {skip: skip, limit: @fetchTopicLimit}).then (topics) =>

                            @topics.push topic for topic in topics

                            @fetchTopicPage++

                            @fetchingTopic = false
    ]