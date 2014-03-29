define ['app'], (app) ->

    app.register.controller 'ForumController', ['$rootScope', '$scope', '$routeParams', 'Forum', ($rootScope, $scope, $routeParams, Forum) ->

        $rootScope.pageTitle = "Admin Console"

        $scope.forum = null

        Forum.findById($routeParams.id).then (forum) ->

            $scope.forum = forum

            if forum 

                forum.fetchMoreTopics()

    ]