define ['app', 'UserService'], (app) ->

    app.register.controller 'LoginController', ['$rootScope', '$scope', '$location', '$alert', '$log', '$translate', 'UserService', ($rootScope, $scope, $location, $alert, $log, $translate, userService) ->

        $translate('LOGIN.TITLE').then (title) ->

            $translate('COMMONS.INNER_PAGE_TITLE', title: title).then (pageTitle) ->

                $rootScope.pageTitle = pageTitle

        $scope.user = 
            username: ''
            password: ''

        loginSuccessCallback = (user) ->

            if $rootScope.prevPath  

                prevPath = $rootScope.prevPath

                $rootScope.prevPath = undefined

                $location.path prevPath 

            else

                $location.path '/'

        loginFailureCallback = () ->

            $scope.loginFailure = true

        $scope.login = (user) ->

            userService.login(user).then loginSuccessCallback, loginFailureCallback

    ]