define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'User', ['CommunicationService', 'promiseTask', 'ResourceFactory', (communicationService, promiseTask, resourceFactory) ->

        resourceFactory '/user',

            instanceProperties: 

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