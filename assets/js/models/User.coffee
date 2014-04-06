define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'User', ['CommunicationService', 'promiseTask', 'ResourceFactory', (communicationService, promiseTask, resourceFactory) ->

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

                isDataAvailable: (data, action) ->

                    promiseTask (deferred) =>

                        communicationService.get("/user/#{action}/#{data}").then (response) =>

                            deferred.resolve response

                isEmailAvailable: () ->

                    @isDataAvailable(@email, 'isEmailAvailable').then (response) =>

                        @emailAvailable = response

                isUsernameAvailable: () ->

                    @isDataAvailable(@username, 'isUsernameAvailable').then (response) =>

                        @usernameAvailable = response
    ]