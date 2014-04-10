define ['app', 'classes/Module'], (app, Module) ->

    app.register.factory 'ResourceFactory', ['$rootScope', '$injector', 'CommunicationService', 'promiseTask', ($rootScope, $injector, communicationService, promiseTask) ->

        (modelName, basePath, options) ->

            options = {} if not options
            options.relatedModels = {} if not options.relatedModels
            options.classProperties = {} if not options.classProperties
            options.instanceMethods = {} if not options.instanceMethods
            options.instanceVariables = {} if not options.instanceVariables

            defaultOptions = 

                insertableAttributes: {}
                updatableAttributes: 
                    id: true

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

                                deferred.resolve results

                            , (error) ->

                                deferred.reject error

                    create: (data) ->

                        new Resource data

                    findAll: (skip, limit) ->

                        promiseTask (deferred) ->

                            skip ?= 0
                            limit ?= 20

                            params = 
                                skip: skip
                                limit: limit

                            Resource.action(null, params, 'get')

                            .then (datas) ->

                                if datas and angular.isArray datas

                                    async.map datas 

                                    , (data, callback) ->

                                        callback null, Resource.create data

                                    , (err, results) ->

                                        deferred.resolve results

                                else if datas

                                    deferred.resolve Resource.create datas

                            , (err) ->

                                deferred.reject err

                    findAllByPaginate: (page, limit) ->

                        Resource.findAll(Resource.calculateSkipByPage(page), limit)

                    findById: (id) ->

                        promiseTask (deferred) ->

                            Resource.action("/#{id}", null, 'get')

                            .then (data) ->

                                deferred.resolve Resource.create data

                            , (err) ->

                                deferred.reject err

                    calculateSkipByPage: (page, limit = 20) ->

                        if not page or page < 1

                            skip = 0 

                        else

                            skip = (page - 1) * limit

                        skip

                instanceVariables:

                    isModel: true

                instanceMethods:

                    save: () ->

                        @constructor.action(null, @fetchInstanceParams(defaultOptions.insertableAttributes), 'post')

                    update: () ->

                        @constructor.action(null, @fetchInstanceParams(defaultOptions.updatableAttributes), 'put')

                    destroy: () ->

                        @constructor.action("/#{@.id}", null, 'delete')

                    copyDataToInstance: (data) ->

                        for key, value of data

                            if @[key] and @[key].isModel

                                @[key].releaseReference()

                            @[key] = value 

                        @[datePropertie] = moment(@[datePropertie]).toDate() for datePropertie of defaultOptions.dateProperties when @[datePropertie]

                        for modelName, properties of defaultOptions.relatedModels

                            @loadModelDependencyAndConvertPropertiesToModels modelName, properties

                    fetchInstanceParams: (attributes) ->

                        params = {}

                        for key, value of @

                            if attributes 

                                params[key] = value if attributes[key]

                            else

                                params[key] = value if value? and typeof value != 'function' 

                        params

                    convertDataToRelatedModel: (modelClass, datas) ->

                        if _.isArray datas

                            values = []

                            for data in datas

                                if not data.isModel

                                    values.push modelClass.create data

                                else

                                    values.push data

                            values

                        else

                            modelClass.create datas if datas

                    convertPropertiesToModels: (modelClass, properties) ->

                        if _.isArray properties

                            for property in properties

                                @[property] = @convertDataToRelatedModel modelClass, @[property] if @[property] and not @[property].isModel

                        else 

                            property = properties

                            @[property] = @convertDataToRelatedModel modelClass, @[property] if @[property] and not @[property].isModel

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

                            @copyDataToInstance message.data
                            $rootScope.$apply()

                        else if event.name is @constructor.identity and message.action is 'destroy'

                            @releaseReference()

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

                                if model.id is data.id 

                                    model.releaseReference() if model.isModel

                                    callback false

                                else 

                                    callback true

                            , (results) ->

                                @[property] = results
                                $rootScope.$apply()

                        else if @[property]

                            @[property] = null if @[property].id is data

                    releaseReference: () ->

                        async.parallel [

                            (rootCallback) =>

                                async.each @listenerCallbacks

                                , (listenerCallback, callback) ->

                                    listenerCallback()

                                    callback null

                                , (err) =>

                                    @listenerCallbacks = []

                                    rootCallback null

                            , (rootCallback) =>

                                for modelName, properties of defaultOptions.relatedModels

                                    if _.isArray properties

                                        async.each properties

                                        , (property, callback) =>

                                            if @[property] and _.isArray @[property]

                                                item.releaseReference() for item in @[property] when item.isModel

                                            else if @[property] and @[property].isModel

                                                @[property].releaseReference()

                                            callback null

                                        , (err) ->

                                    else if @[properties] and @[properties].isModel

                                        @[properties].releaseReference()

                        ]

            for key, value of options

                defaultOptions[key] = {} if not defaultOptions[key]

                angular.extend(defaultOptions[key], options[key])

            class Resource extends Module

                @extend defaultOptions.classProperties
                @include defaultOptions.instanceMethods

                constructor: (data) ->

                    @[key] = value for key, value of defaultOptions.instanceVariables

                    @listenerCallbacks = []

                    @listenerCallbacks.push $rootScope.$on @constructor.identity, (event, message) =>

                        @handleUpdateEvent event, message

                    for modelName, properties of defaultOptions.relatedModels

                        @listenerCallbacks.push $rootScope.$on modelName, (event, message) =>

                            @handleRelatedModelEvent event, message

                    if data

                        @copyDataToInstance data

                    if defaultOptions.instanceMethods.init

                        defaultOptions.instanceMethods.init.apply @
    ]