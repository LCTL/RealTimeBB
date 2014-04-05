define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Topic', ['$rootScope', 'ResourceFactory', 'CommunicationService', ($rootScope, resourceFactory, communicationService) ->

        communicationService.listenEvent 'Post'

        basePath = '/topic'

        resourceFactory basePath, 

            instanceVariables:
                posts: null
                fetchPostPage: 1
                fetchPostLimit: 20
                fetchingPost: false
                allLoaded: false

            instanceMethods: 

                init: () ->

                    @posts = []

                    $rootScope.$on 'Post', (event, message) =>

                        if message.action is 'create' and @allLoaded and @id is message.data.topicId

                            @posts.push message.data
                            $rootScope.$apply()

                        else if message.action is 'update' and @id is message.data.topicId

                            async.each @posts

                            , (item, callback) ->

                                if message.data.id is item.id

                                    angular.copy message.data, item

                                callback null

                            , (err) ->

                                $rootScope.$apply()

                        else if message.action is 'destroy' and @id is message.data.topicId

                            async.filter @posts

                            , (item, callback) ->

                                if message.data.id is item.id

                                    callback false

                                else 

                                    callback true

                            , (err, results) ->

                                @posts = results
                                $rootScope.$apply()

                fetchMorePosts: () ->

                    if not @fetchingPost and not @allLoaded

                        @fetchingPost = true

                        path = "#{basePath}/#{@id}/posts"

                        skip = @constructor.calculateSkipByPage @fetchPostPage

                        communicationService.get(path, {skip: skip, limit: @fetchPostLimit}).then (posts) =>

                            if posts and not _.isEmpty posts

                                @posts = [] if not @posts

                                @posts.push post for post in posts

                                @fetchPostPage++

                            else if _.isEmpty posts

                                @allLoaded = true

                            @fetchingPost = false
    ]