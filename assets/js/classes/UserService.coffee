define [], () ->

    class UserService

        @$inject: ['$log', '$rootScope', 'CommunicationService', 'promiseTask']

        constructor: (@$log, @$rootScope, @communicationService, @promiseTask) ->

        isLoggedIn: () ->

            if @$rootScope.user then true else false

        setCurrentUser: (user) ->

            @$rootScope.user = user

        hasRoles: (roles) ->

            if @isLoggedIn() and @$rootScope.user.roles

                if _.isArray(roles) 

                    for role in roles

                        result = _.contains @$rootScope.user.roles, role

                        return result if result

                else 

                    return _.contains @$rootScope.user.roles, role

            else

                false 

        register: (user) ->

            @promiseTask (deferred) =>

                @communicationService.post('/user/register', user).then (data) =>

                    @$log.debug data

                    if data.username

                        @setCurrentUser data
                        deferred.resolve data

                    else

                        deferred.reject data

        login: (user) ->

            @promiseTask (deferred) =>

                @communicationService.post('/user/login', user).then (user) =>

                    if user

                        @setCurrentUser user
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