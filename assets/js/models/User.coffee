define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'User', ['CommunicationService', 'Utils', 'ResourceFactory', (communicationService, utils, resourceFactory) ->

        communicationService.listenEvent 'User'

        resourceFactory 'User', '/user',

            insertableAttributes: 
                email: true
                username: true
                password: true

            updatableAttributes:
                email: true
                username: true
                password: true

            instanceMethods: 

                hasRole: (role) ->

                    if @roles then $root.user.roles.indexOf(role) != -1 else false 

                isDataAvailable: (data, action, asyncCallback) ->

                    utils.promiseTask asyncCallback, (deferred) =>

                        communicationService.get("/user/#{action}/#{data}").then (response) =>

                            deferred.resolve response

                isEmailAvailable: () ->

                    @isDataAvailable(@email, 'isEmailAvailable').then (response) =>

                        @emailAvailable = response

                isUsernameAvailable: () ->

                    @isDataAvailable(@username, 'isUsernameAvailable').then (response) =>

                        @usernameAvailable = response
    ]