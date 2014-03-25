define [], () ->

    class ResourceFactory

        @$inject: ['CommunicationService', 'promiseTask']

        constructor: (@CommunicationService, @promiseTask) ->

        create: (basePath) ->

            class Resource

                @action: (additionalPath, params, method) ->

                    @promiseTask (deferred) ->

                        if additionalPath

                            path = basePath + additionalPath 

                        else 

                            path = basePath

                        @communicationService.action(path, params, method)

                        .then (results) ->

                            if results and angular.isArray results

                                async.map results 

                                , (item, callback) ->

                                    callback null, Resource.newInstance item

                                , (err, results) ->

                                    deferred.resolve results

                            else if results

                                deferred.resolve Resource.newInstance results

                        , (error) ->

                            deferred.reject error

                @newInstance: (data) ->

                    new Resource data

                @findAll: (skip, limit) ->

                    skip ?= 0
                    limit ?= 20

                    params = 
                        skip: skip
                        limit: limit

                    Resource.action(null, params, 'get')

                @findAllByPaginate: (page, limit) ->

                    limit ?= 20

                    if not page or page < 1

                        skip = 0 

                    else

                        skip = (page - 1) * limit

                    Resource.findAll(page, limit)

                @findById: (id) ->

                    Resource.action("/#{id}", null, 'get')

                constructor: (data) ->

                    if data

                        @copyPropertyToInstance data

                save: () ->

                    Resource.action(null, @fetchInstanceParams(), 'post')

                update: () ->

                    Resource.action(null, @fetchInstanceParams(), 'put')

                remove: () ->

                    Resource.action("/#{@.id}", @fetchInstanceParams(), 'delete')

                copyPropertyToInstance: (properties) ->

                    @[key] = value for key, value of properties

                fetchInstanceParams: () ->

                    params = {}

                    for key, value of @

                        params[key] = value if value and typeof value != 'function' 

                    params