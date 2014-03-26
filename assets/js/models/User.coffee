define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'User', ['ResourceFactory', (resourceFactory) ->

        User = resourceFactory('/user')

    ]