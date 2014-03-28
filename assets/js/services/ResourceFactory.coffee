define ['app', 'classes/Module'], (app, Module) ->

    app.register.factory 'ResourceFactory', ['CommunicationService', 'promiseTask', (communicationService, promiseTask) ->

        (basePath, options) ->

            options = {} if not options
            options.classProperties = {} if not options.classProperties
            options.instanceProperties = {} if not options.instanceProperties

            defaultOptions = 

                classProperties: 

                    action: (additionalPath, params, method) ->
                        promiseTask (deferred) ->

                            if additionalPath

                                path = basePath + additionalPath 

                            else 

                                path = basePath

                            communicationService.action(path, params, method)

                            .then (results) ->

                                if results and angular.isArray results

                                    async.map results 

                                    , (item, callback) ->

                                        callback null, Resource.create item

                                    , (err, results) ->

                                        deferred.resolve results

                                else if results

                                    deferred.resolve Resource.create results

                            , (error) ->

                                deferred.reject error

                    create: (data) ->

                        new Resource data

                    findAll: (skip, limit) ->

                        skip ?= 0
                        limit ?= 20

                        params = 
                            skip: skip
                            limit: limit

                        Resource.action(null, params, 'get')

                    findAllByPaginate: (page, limit) ->

                        limit ?= 20

                        if not page or page < 1

                            skip = 0 

                        else

                            skip = (page - 1) * limit

                        Resource.findAll(skip, limit)

                    findById: (id) ->

                        Resource.action("/#{id}", null, 'get')

                instanceProperties:

                    save: () ->

                        @constructor.action(null, @fetchInstanceParams(), 'post')

                    update: () ->

                        @constructor.action(null, @fetchInstanceParams(), 'put')

                    delete: () ->

                        @constructor.action("/#{@.id}", @fetchInstanceParams(), 'delete')

                    copyPropertyToInstance: (properties) ->

                        @[key] = value for key, value of properties

                    fetchInstanceParams: () ->

                        params = {}

                        for key, value of @

                            params[key] = value if value and typeof value != 'function' 

                        params

            for key, value of options

                defaultOptions[key] = {} if not defaultOptions[key]

                angular.extend(defaultOptions[key], options[key])

            class Resource extends Module

                @extend defaultOptions.classProperties
                @include defaultOptions.instanceProperties

                constructor: (data) ->

                    if data

                        @copyPropertyToInstance data

    ]