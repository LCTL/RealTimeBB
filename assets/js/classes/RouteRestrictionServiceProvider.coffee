define [], () ->

    class RouteRestrictionService

        constructor: (@$rootScope, @$location, @userService, @loginPage, @restricts) ->

        toLoginPage: () ->

            @$rootScope.prevPath = @$location.path()

            @$location.path @loginPage

        $routeChangeStart: (next, current) ->

            for restrict in @restricts

                if _.str.startsWith current.$$route.segment, restrict.segment

                    @$rootScope.prevPath = current.$$route.originalPath

                    @$location.path @loginPage if not @userService.hasRoles restrict.roles

    class RouteRestrictionServiceProvider

        constructor: () ->

            @loginPage = '/login'
            @restricts = []

        $get: ['$rootScope', '$location', 'UserService', ($rootScope, $location, userService) ->

            routeRestrictionService = new RouteRestrictionService $rootScope, $location, userService, @loginPage, @restricts

            $rootScope.$on '$routeChangeStart', (next, current) ->

                routeRestrictionService.$routeChangeStart next, current

            routeRestrictionService

        ]

    return new RouteRestrictionServiceProvider()