define ['app', 'Markdown', 'Topic', 'Post'], (app) ->

    app.register.controller 'TopicController', ['$rootScope', '$scope', '$routeParams', 'UserService', 'Topic', 'Post', ($rootScope, $scope, $routeParams, userService, Topic, Post) ->

        $rootScope.pageTitle = "Admin Console"

        $scope.topic = null

        Topic.findById($routeParams.id).then (topic) ->

            $scope.topic = topic
            $scope.replyPost = Post.create
                topicId: topic.id

            if topic 

                topic.fetchMorePosts()

        $scope.reply = (post) ->

            post.save().then (post) ->

                $scope.replyPost.content = ''

        $scope.isLoggedIn = () ->

            userService.isLoggedIn()

        $scope.$on '$destroy', () ->

            $scope.topic?.releaseReference()
            $scope.replyPost?.releaseReference()

    ]