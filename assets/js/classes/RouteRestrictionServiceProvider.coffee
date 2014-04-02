define [], () ->

    class RouteRestrictionServiceProvider

        constructor: () ->

            @loginPage = '/login'
            @restricts = []

        $get: ['$rootScope', '$location', 'UserService', ($rootScope, $location, userService) ->

            $rootScope.$on '$routeChangeStart', (next, current) =>

                for restrict in @restricts

                    if _.str.startsWith current.$$route.segment, restrict.segment

                        $rootScope.prevPath = current.$$route.originalPath

                        $location.path @loginPage if not userService.hasRoles restrict.roles

        ]