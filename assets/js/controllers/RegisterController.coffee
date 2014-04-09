define ['app', 'UserService', 'User'], (app) ->

    app.register.controller 'RegisterController', ['$rootScope', '$scope', '$location', 'UserService', 'User', ($rootScope, $scope, $location, userService, User) ->

        checkingUsername = false
        checkUserDataAvailableLocking = false

        $rootScope.pageTitle = 'Register'
        $scope.user = User.create()

        listenerCallbacks = []

        listenerCallbacks.push $scope.$watch 'user.username', (newValue, oldValue) ->
            
            $scope.user.isUsernameAvailable()

        listenerCallbacks.push $scope.$watch 'user.email', (newValue, oldValue) ->

            $scope.user.isEmailAvailable()

        listenerCallbacks.push $scope.$watch 'user.passwordConfirmation', (newValue, oldValue) ->

            if newValue != $scope.user.password

                $scope.passwordMatch = false

            else

                $scope.passwordMatch = true

        $scope.register = (user) ->

            if $scope.passwordMatch and $scope.user.emailAvailable and $scope.user.usernameAvailable

                userService.register(user).then (user) ->

                    $location.path '/'

        $scope.$on '$destroy', () ->

            $scope.user?.releaseReference()

            listenerCallback() for listenerCallback in listenerCallbacks

    ]