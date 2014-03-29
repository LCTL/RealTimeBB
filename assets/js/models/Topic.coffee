define ['app', 'ResourceFactory'], (app) ->

    app.register.factory 'Topic', ['ResourceFactory', 'CommunicationService', (resourceFactory, communicationService) ->

        basePath = '/topic'

        resourceFactory basePath, 

            instanceVariables:
                posts: null
                fetchPostPage: 1
                fetchPostLimit: 20
                fetchingPost: false

            instanceMethods: 

                fetchMorePosts: () ->

                    if not @fetchingPost

                        @fetchingPost = true

                        path = "#{basePath}/#{@id}/posts"

                        skip = @constructor.calculateSkipByPage @fetchPostPage

                        communicationService.get(path, {skip: skip, limit: @fetchPostLimit}).then (posts) =>

                            if posts

                                @posts = [] if not @posts

                                @posts.push post for post in posts

                                @fetchPostPage++

                            @fetchingPost = false
    ]