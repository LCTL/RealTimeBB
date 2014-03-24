define ['app', 'CommunicationService'], (app) ->

    app.register.service 'UserService', ['$log', '$q', '$rootScope', 'CommunicationService', 

        class UserService

            constructor: (@$log, @$q, @$rootScope, @communicationService) ->

            setCurrentUser: (user) ->

                @$rootScope.user = user

            getCurrentUser: ->

                deferred = @$q.defer()

                if @$rootScope.user

                    deferred.resolve @$rootScope.user

                else

                    @communicationService.get('/user/current').then (user) =>

                        @$log.debug user

                        @$rootScope.user = user

                        deferred.resolve user

                return deferred.promise

            checkUserDataAvailable: (data, action) ->

                deferred = @$q.defer()

                @communicationService.get("/user/#{action}/#{data}").then (response) =>
                
                    @$log.debug response

                    deferred.resolve response

                return deferred.promise

            register: (user) ->

                deferred = @$q.defer()

                @communicationService.post('/user/register', user).then (data) =>

                    @$log.debug data

                    if data.username

                        @$rootScope.user = data
                        deferred.resolve data

                    else

                        deferred.reject data

                return deferred.promise

            login: (user) ->

                deferred = @$q.defer()

                @communicationService.post('/user/login', user).then (user) =>

                    if user

                        @$rootScope.user = user
                        deferred.resolve user

                    else

                        deferred.reject user

                return deferred.promise

            logout: () ->

                deferred = @$q.defer()

                @communicationService.get('/user/logout').then (result) =>

                    if result 
                        
                        @$rootScope.user = null

                        deferred.resolve true 

                    else 

                        deferred.reject false

                return deferred.promise

            isEmailAvailable: (email) -> 

                @checkUserDataAvailable email, 'isEmailAvailable'

            isUserNameAvailable: (username) -> 

                @checkUserDataAvailable username, 'isUsernameAvailable'

    ]