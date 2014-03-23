define ['app', 'CommunicationService'], (app) ->

    app.register.service 'UserService', ['$q', '$log', '$rootScope', 'CommunicationService', ($q, $log, $rootScope, communicationService) ->

        checkAvailable = (data, action) ->

            deferred = $q.defer()

            communicationService.get("/user/#{action}/#{data}").then (response) ->
            
                $log.debug response

                deferred.resolve response

            return deferred.promise

        register: (user) ->

            deferred = $q.defer()

            communicationService.post('/user/register', user).then (data) ->

                $log.debug data

                if data.username

                    $rootScope.user = data
                    deferred.resolve data

                else

                    deferred.reject data

            return deferred.promise

        login: (user) ->

            deferred = $q.defer()

            communicationService.post('/user/login', user).then (user) ->

                if user

                    $rootScope.user = user
                    deferred.resolve user

                else

                    deferred.reject user

            return deferred.promise

        current: () ->

            deferred = $q.defer()

            if $rootScope.user

                deferred.resolve $rootScope.user

            else

                communicationService.get('/user/current').then (user) ->

                    $log.debug user

                    deferred.resolve user

            return deferred.promise

        isEmailAvailable: (email) -> checkAvailable email, 'isEmailAvailable'

        isUserNameAvailable: (username) -> checkAvailable username, 'isUsernameAvailable'

    ]