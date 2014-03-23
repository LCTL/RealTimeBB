define ['app', 'UserService'], (app) ->

    app.register.controller 'LoginController', ['$rootScope', '$scope', '$location', '$alert', '$log', 'UserService', ($rootScope, $scope, $location, $alert, $log, userService) ->

        $rootScope.pageTitle = 'Login'

        $scope.user = 
            username: ''
            password: ''

        loginSuccessCallback = (user) ->

            $location.path '/'

        loginFailureCallback = () ->

            $scope.loginFailure = true

        $scope.login = (user) ->

            userService.login(user).then loginSuccessCallback, loginFailureCallback

    ]