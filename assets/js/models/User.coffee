define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'User', ['CommunicationService', 'promiseTask', 'ResourceFactory', (communicationService, promiseTask, resourceFactory) ->

        UserResource = resourceFactory('/user')

        class User extends UserResource

            isDataAvailable: (data, action) ->

                promiseTask (deferred) =>

                    communicationService.get("/user/#{action}/#{data}").then (response) =>

                        deferred.resolve response

            isEmailAvailable: () ->

                @isDataAvailable(@email, 'isEmailAvailable')

            isUsernameAvailable: () ->

                @isDataAvailable(@username, 'isUsernameAvailable')

    ]