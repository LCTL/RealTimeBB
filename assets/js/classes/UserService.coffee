define [], () ->

    class UserService

        @$inject: ['$log', '$rootScope', 'CommunicationService', 'promiseTask']

        constructor: (@$log, @$rootScope, @communicationService, @promiseTask) ->

        setCurrentUser: (user) ->

            @$rootScope.user = user

        getCurrentUser: ->

            @promiseTask (deferred) =>

                if @$rootScope.user

                    deferred.resolve @$rootScope.user

                else

                    @communicationService.get('/user/current').then (user) =>

                        @$log.debug user

                        @$rootScope.user = user

                        deferred.resolve user

        checkUserDataAvailable: (data, action) ->

            @promiseTask (deferred) =>

                @communicationService.get("/user/#{action}/#{data}").then (response) =>
                
                    @$log.debug response

                    deferred.resolve response

        register: (user) ->

            @promiseTask (deferred) =>

                @communicationService.post('/user/register', user).then (data) =>

                    @$log.debug data

                    if data.username

                        @$rootScope.user = data
                        deferred.resolve data

                    else

                        deferred.reject data

        login: (user) ->

            @promiseTask (deferred) =>

                @communicationService.post('/user/login', user).then (user) =>

                    if user

                        @$rootScope.user = user
                        deferred.resolve user

                    else

                        deferred.reject user

        logout: () ->

            @promiseTask (deferred) =>

                @communicationService.get('/user/logout').then (result) =>

                    @$log.debug "logout %s", result

                    if result 
                        
                        @$rootScope.user = null
                        deferred.resolve true 

                    else 

                        deferred.reject false

        isEmailAvailable: (email) -> 

            @checkUserDataAvailable email, 'isEmailAvailable'

        isUserNameAvailable: (username) -> 

            @checkUserDataAvailable username, 'isUsernameAvailable'