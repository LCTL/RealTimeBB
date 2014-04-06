define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Post', ['CommunicationService', 'ResourceFactory', (communicationService, resourceFactory) ->

        communicationService.listenEvent 'Post'

        basePath = '/post'

        resourceFactory 'Post', basePath,

            insertableAttributes: 
                topicId: true
                content: true

            updatableAttributes:
                topicId: true
                content: true
        
    ]