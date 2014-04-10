define [], () ->

    class Utils

        @$inject: ['$q']

        constructor: (@$q) ->

        promiseTask: (asyncCallback, fn) ->

            deferred = @$q.defer()

            innerDeferred = @$q.defer()
            innerPromise = innerDeferred.promise

            fn innerDeferred

            innerPromise.then (obj) ->

                if asyncCallback then asyncCallback null, obj else deferred.resolve obj

            , (err) ->

                if asyncCallback then asyncCallback err else deferred.reject err

            , (notifyMessage) ->

                deferred.notify notifyMessage

            deferred.promise