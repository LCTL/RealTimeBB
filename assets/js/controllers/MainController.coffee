define ['app', 'UserService'], (app) ->

    app.register.controller 'MainController', ['$rootScope', '$scope', 'UserService', ($rootScope, $scope, userService) ->

        $rootScope.pageTitle = "RealTimeBB"

    ]

