define ['app', 'UserService'], (app) ->

    app.controller 'MainController', ['$rootScope', '$scope', 'UserService', ($rootScope, $scope, userService) ->

        $rootScope.pageTitle = "RealTimeBB"

    ]

