Q = require 'q'

module.exports =

    promiseTask : (asyncCallback, fn) ->

        deferred = Q.defer()

        innerDeferred = Q.defer()
        innerPromise = innerDeferred.promise

        fn innerDeferred

        innerPromise.then (obj) ->

            if asyncCallback then asyncCallback null, obj else deferred.resolve obj

        , (err) ->

            if asyncCallback then asyncCallback err else deferred.reject err

        , (notifyMessage) ->

            deferred.notify notifyMessage

        deferred.promise