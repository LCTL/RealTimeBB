define [], () ->

    class CommunicationService

        @$inject: ['$rootScope', '$log', 'socket.io', 'csrf', 'Utils']

        constructor: (@$rootScope, @$log, @io, @csrf, @utils) ->

            @connectSocket()

            @baseApiUrl = '/api'
            @listenedEvents = {}

        connectSocket: ->

            if not @connected

                @socket = @io.connect()

                @socket.on 'connect', =>

                    @$log.debug 'socket connected'

                    @connected = true

                    @listenEvent 'message'

                @socket.on 'disconnect', =>

                    @$log.debug 'socket disconnected'

                    @connected = false

        action: (path, data, method, needCsrf, asyncCallback) ->

            @utils.promiseTask asyncCallback, (deferred) =>

                if typeof needCsrf == 'undefined' and method != 'get'

                    needCsrf = true

                if needCsrf

                    data = {} if not data

                    angular.extend data, _csrf: @csrf

                @socket[method] @baseApiUrl + path, data, (response) =>

                    if response and response.status and (response.status >= 300 or response.status < 200)

                        deferred.reject response

                    else

                        deferred.resolve response

        get: (path, data) ->

            @action(path, data, 'get', false)

        post: (path, data) ->

            @action(path, data, 'post')

        put: (path, data) ->

            @action(path, data, 'put')

        delete: (path, data) ->

            @action(path, data, 'delete')

        listenEvent: (eventName) ->

            if not @listenedEvents[eventName]

                @listenedEvents[eventName] = true

                @socket.on eventName, (message) =>

                    @$rootScope.$broadcast eventName, message

        emit: (event, message) ->

            @socket.emit event, message