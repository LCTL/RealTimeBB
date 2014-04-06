define ['app', 'classes/Module'], (app, Module) ->

    app.register.factory 'ResourceFactory', ['$rootScope', '$injector', 'CommunicationService', 'promiseTask', ($rootScope, $injector, communicationService, promiseTask) ->

        (modelName, basePath, options) ->

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

                    identity: modelName

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

                    destroy: () ->

                        @constructor.action("/#{@.id}", @fetchInstanceParams(), 'delete')

                    copyPropertyToInstance: (properties) ->

                        @[key] = value for key, value of properties

                        @[datePropertie] = moment(@[datePropertie]).toDate() for datePropertie of defaultOptions.dateProperties when @[datePropertie]

                        for modelName, properties of defaultOptions.relatedModels

                            @loadModelDependencyAndConvertPropertiesToModels modelName, properties

                    fetchInstanceParams: () ->

                        params = {}

                        for key, value of @

                            params[key] = value if value? and typeof value != 'function' 

                        params

                    convertDataToRelatedModel: (modelClass, datas) ->

                        if _.isArray datas

                            values = []

                            for data in datas

                                values.push modelClass.create data

                            values

                        else

                            modelClass.create datas if datas

                    convertPropertiesToModels: (modelClass, properties) ->

                        if _.isArray properties

                            for property in properties

                                @[property] = @convertDataToRelatedModel modelClass, @[property] if @[property]

                        else 

                            property = properties

                            @[property] = @convertDataToRelatedModel modelClass, @[property] if @[property]

                    loadModelDependency: (modelName, asyncCallback) ->

                        if @constructor[modelName]

                            asyncCallback(@constructor[modelName])

                        else 

                            requires = []
                            requires.push modelName

                            requirejs requires, () =>

                                @constructor[modelName] = $injector.get(modelName)

                                asyncCallback(@constructor[modelName])

                    loadModelDependencyAndConvertPropertiesToModels: (modelName, properties) ->

                        @loadModelDependency modelName, (modelClass) =>

                            @convertPropertiesToModels modelClass, properties

                    handleUpdateEvent: (event, message) ->

                        if event.name is @constructor.identity and message.action is 'update' and message.data.id is @id

                            @copyPropertyToInstance message.data
                            $rootScope.$apply()

                    handleRelatedModelEvent: (event, message) ->

                        properties = defaultOptions.relatedModels[event.name]

                        if not _.isArray properties

                            temp = properties
                            properties = []
                            properties.push temp

                        async.each properties

                        , (property, callback) =>

                            if message.action is 'destroy'

                                @destroyModelPropertyData property, message.data

                        , (err) ->

                            $rootScope.$apply()

                    destroyModelPropertyData: (property, data) ->

                        if @[property] and _.isArray @[property]

                            async.filter @[property]

                            , (model, callback) ->

                                if model.id is data then callback false else callback true

                            , (results) ->

                                @[property] = results
                                $rootScope.$apply()

                        else if @[property]

                            @[property] = null if @[property].id is data

            for key, value of options

                defaultOptions[key] = {} if not defaultOptions[key]

                angular.extend(defaultOptions[key], options[key])

            class Resource extends Module

                @extend defaultOptions.classProperties
                @include defaultOptions.instanceMethods

                constructor: (data) ->

                    @[key] = value for key, value of defaultOptions.instanceVariables

                    $rootScope.$on @constructor.identity, (event, message) =>

                        @handleUpdateEvent event, message

                    for modelName, properties of defaultOptions.relatedModels

                        $rootScope.$on modelName, (event, message) =>

                            @handleRelatedModelEvent event, message

                    if data

                        @copyPropertyToInstance data

                    if defaultOptions.instanceMethods.init

                        defaultOptions.instanceMethods.init.apply @
    ]