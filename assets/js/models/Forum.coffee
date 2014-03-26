define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Forum', ['ResourceFactory', (resourceFactory) ->

        User = resourceFactory('/forum')

    ]