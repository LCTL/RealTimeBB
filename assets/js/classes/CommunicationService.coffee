define [], () ->

    class CommunicationService

        @$inject: ['$log', '$q', 'socket.io', 'csrf']

        constructor: (@$log, @$q, @io, @csrf) ->

            @connectSocket()

        connectSocket: ->

            if not @connected

                @socket = @io.connect()

                @socket.on 'connect', =>

                    @$log.debug 'socket connected'

                    @connected = true

                @socket.on 'disconnect', =>

                    @$log.debug 'socket disconnected'

                    @connected = false

        action: (path, data, method, needCsrf) ->

            deferred = @$q.defer()

            if typeof needCsrf == 'undefined'

                needCsrf = true

            if needCsrf

                data = {} if not data

                angular.extend data, _csrf: @csrf

            @socket[method] path, data, (response) =>

                @$log.debug 'action %s', method

                @$log.debug response

                if response and response.status and (response.status >= 300 or response.status < 200)

                    @$log.debug 'reject'

                    deferred.reject response

                else

                    @$log.debug 'resolve'

                    deferred.resolve response

            return deferred.promise

        get: (path, data) ->

            @action(path, data, 'get', false)

        post: (path, data) ->

            @action(path, data, 'post')

        put: (path, data) ->

            @action(path, data, 'put')

        delete: (path, data) ->

            @action(path, data, 'delete')

        addListener: (event, filter, listener) ->

            wrapper = 

                filter: filter

                listener: listener

            if not @listeners[event]

                @listeners[event] = []

                @socket.on event, (message) =>

                    eventIterator = (wrapper, callback) ->

                        #TODO compare message data is equal filter specific value

                        wrapper.listener message

                        callback false

                    async.each @listeners[event], eventIterator, (error) =>

                        @$log.error error if error

            @listeners[event].push wrapper

        removeListener: (event, listener) ->

            if @listeners[event]

                iterator = (wrapper, callback) =>

                    if wrapper.listener == listener then callback(false) else callback(true)

                async.filter @listeners[event], iterator, (results) =>

                    @listeners[event] = results

        emit: (event, message) ->

            @socket.emit event, message