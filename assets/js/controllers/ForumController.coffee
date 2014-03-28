define ['app'], (app) ->

    app.register.controller 'ForumController', ['$rootScope', '$scope', '$routeParams', 'Forum', ($rootScope, $scope, $routeParams, Forum) ->

        $rootScope.pageTitle = "Admin Console"

        $scope.forum = null

        Forum.findById($routeParams.id).then (forum) ->

            console.dir forum

            $scope.forum = forum

            if forum 

                forum.fetchMoreTopics()

    ]