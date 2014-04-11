define [], () ->

    class UserService

        @$inject: ['$log', '$rootScope', 'CommunicationService', 'Utils']

        constructor: (@$log, @$rootScope, @communicationService, @utils) ->

            @communicationService.listenEvent 'User'

            @$rootScope.$on 'User', (event, message) =>

                if message.action is 'logout'

                    @$rootScope.user = null

                    @$rootScope.$apply()

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

        register: (user, asyncCallback) ->

            @utils.promiseTask asyncCallback, (deferred) =>

                @communicationService.post('/user/register', user).then (data) =>

                    @$log.debug data

                    if data.username

                        @setCurrentUser data
                        deferred.resolve data

                    else

                        deferred.reject data

        login: (user, asyncCallback) ->

            @utils.promiseTask asyncCallback, (deferred) =>

                @communicationService.post('/user/login', user).then (user) =>

                    if user

                        @setCurrentUser user
                        deferred.resolve user

                    else

                        deferred.reject user

        logout: (asyncCallback) ->

            @utils.promiseTask asyncCallback, (deferred) =>

                @communicationService.get('/user/logout').then (result) =>

                    @$log.debug "logout %s", result

                    if result 
                        
                        @$rootScope.user = null
                        deferred.resolve true 

                    else 

                        deferred.reject false