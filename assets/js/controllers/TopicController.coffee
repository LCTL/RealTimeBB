define ['app', 'Markdown', 'Topic', 'Post'], (app) ->

    app.register.controller 'TopicController', ['$rootScope', '$scope', '$routeParams', '$translate', 'UserService', 'Topic', 'Post', ($rootScope, $scope, $routeParams, $translate, userService, Topic, Post) ->

        $scope.topic = null

        Topic.findById($routeParams.id).then (topic) ->

            $translate('COMMONS.INNER_PAGE_TITLE', title: topic.title).then (pageTitle) ->

                $rootScope.pageTitle = pageTitle

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