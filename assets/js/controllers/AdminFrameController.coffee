define ['app'], (app) ->

    app.register.controller 'AdminFrameController', ['$rootScope', '$scope', '$routeSegment', ($rootScope, $scope, $routeSegment) ->

        $rootScope.pageTitle = "Admin Console"

        $scope.$routeSegment = $routeSegment

    ]