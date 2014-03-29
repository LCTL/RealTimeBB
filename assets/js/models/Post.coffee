define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Post', ['ResourceFactory', (resourceFactory) ->

        basePath = '/post'

        resourceFactory basePath
        
    ]