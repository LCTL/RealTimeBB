define ['app', 'UserService'], (app) ->

    app.register.controller 'RegisterController', ['$rootScope', '$scope', '$location', 'UserService', ($rootScope, $scope, $location, userService) ->

        checkingUsername = false
        checkUserDataAvailableLocking = false

        $rootScope.pageTitle = 'Register'

        $scope.user = 
            email: ''
            username: ''
            password: ''
            passwordConfirmation: ''

        checkUserDataAvailable = (data, userServiceMethod, scopeVariable) ->

            if not checkUserDataAvailableLocking

                checkUserDataAvailableLocking = true

                if data

                    userService[userServiceMethod](data).then (result) ->

                        $scope[scopeVariable] = result
                        checkUserDataAvailableLocking = false

                else

                    $scope[scopeVariable] = false 
                    checkUserDataAvailableLocking = false

        $scope.$watch 'user.username', (newValue, oldValue) ->

            $scope.checkUsernameAvailable newValue

        $scope.$watch 'user.email', (newValue, oldValue) ->

            $scope.checkEmailAvailable newValue

        $scope.$watch 'user.passwordConfirmation', (newValue, oldValue) ->

            if newValue != $scope.user.password

                $scope.passwordMatch = false

            else

                $scope.passwordMatch = true

        $scope.checkUsernameAvailable = (username) ->

            checkUserDataAvailable username, 'isUserNameAvailable', 'usernameAvailable'

        $scope.checkEmailAvailable = (email) ->

            checkUserDataAvailable email, 'isEmailAvailable', 'emailAvailable'

        $scope.register = (user) ->

            if $scope.passwordMatch and $scope.emailAvailable and $scope.usernameAvailable

                userService.register(user).then (user) ->

                    $location.path '/'

    ]