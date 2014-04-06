define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Topic', ['$rootScope', 'ResourceFactory', 'CommunicationService', ($rootScope, resourceFactory, communicationService) ->

        communicationService.listenEvent 'Topic'
        communicationService.listenEvent 'Post'

        basePath = '/topic'

        resourceFactory 'Topic', basePath, 

            insertableAttributes: 
                forumId: true
                title: true
                content: true

            updatableAttributes:
                forumId: true
                title: true

            relatedModels: 
                User: 'user'
                Forum: 'forum'
                Post: ['headPost', 'posts']

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

                            @loadModelDependency 'Post', (Post) =>

                                @posts.push @convertDataToRelatedModel Post, message.data
                                $rootScope.$apply()

                fetchMorePosts: () ->

                    if not @fetchingPost and not @allLoaded

                        @fetchingPost = true

                        path = "#{basePath}/#{@id}/posts"

                        skip = @constructor.calculateSkipByPage @fetchPostPage

                        communicationService.get(path, {skip: skip, limit: @fetchPostLimit}).then (posts) =>

                            if posts and not _.isEmpty posts

                                @loadModelDependency 'Post', (Post) =>

                                    @posts.push @convertDataToRelatedModel Post, post for post in posts

                                    @allLoaded = true if posts.length < @fetchPostLimit

                                    @fetchPostPage++

                            else if _.isEmpty posts

                                @allLoaded = true

                            @fetchingPost = false
    ]