define ['app', 'classes/Module'], (app, Module) ->

    app.register.factory 'ResourceFactory', ['$injector', 'CommunicationService', 'promiseTask', ($injector, communicationService, promiseTask) ->

        (basePath, options) ->

            options = {} if not options
            options.relatedModels = {} if not options.relatedModels
            options.classProperties = {} if not options.classProperties
            options.instanceMethods = {} if not options.instanceMethods
            options.instanceVariables = {} if not options.instanceVariables

            defaultOptions = 

                dateProperties: 
                    createdAt: true,
                    updatedAt: true

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

                        Resource.findAll(Resource.calculateSkipByPage(page), limit)

                    findById: (id) ->

                        Resource.action("/#{id}", null, 'get')

                    calculateSkipByPage: (page, limit = 20) ->

                        if not page or page < 1

                            skip = 0 

                        else

                            skip = (page - 1) * limit

                        skip

                instanceMethods:

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

                    convertDataToRelatedModel: (relatedModelName, datas) ->

                        if _.isArray datas

                            values = []

                            for data in datas

                                values.push @constructor[relatedModelName].create data

                            values

                        else

                            @constructor[relatedModelName].create datas if datas

                    convertPropertiesToModels: (modelName, properties) ->

                        if _.isArray properties

                            for property in properties

                                @[property] = @convertDataToRelatedModel modelName, @[property] if @[property]

                        else 

                            property = properties

                            @[property] = @convertDataToRelatedModel modelName, @[property] if @[property]

                    loadModelDependency: (modelName, asyncCallback) ->

                        if @constructor[modelName]

                            asyncCallback()

                        else 

                            requires = []
                            requires.push modelName

                            requirejs requires, () =>

                                @constructor[modelName] = $injector.get(modelName)

                                asyncCallback()

                    loadModelDependencyAndConvertPropertiesToModels: (modelName, properties) ->

                        @loadModelDependency modelName, () =>

                            @convertPropertiesToModels modelName, properties

            for key, value of options

                defaultOptions[key] = {} if not defaultOptions[key]

                angular.extend(defaultOptions[key], options[key])

            class Resource extends Module

                @extend defaultOptions.classProperties
                @include defaultOptions.instanceMethods

                constructor: (data) ->

                    @[key] = value for key, value of defaultOptions.instanceVariables

                    if data

                        @copyPropertyToInstance data

                        @[datePropertie] = moment(@[datePropertie]).toDate() for datePropertie of defaultOptions.dateProperties when @[datePropertie]

                        for modelName, properties of defaultOptions.relatedModels

                            @loadModelDependencyAndConvertPropertiesToModels modelName, properties

                    if defaultOptions.instanceMethods.init

                        defaultOptions.instanceMethods.init.apply @
    ]