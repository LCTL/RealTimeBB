define ['app', 'Forum'], (app) ->

    app.register.controller 'MainController', ['$rootScope', '$scope', 'Forum', ($rootScope, $scope, Forum) ->

        $rootScope.pageTitle = "RealTimeBB"

        $scope.forums = []
        $scope.busy = false

        page = 1

        $scope.nextPage = () ->

            $scope.busy = true

            Forum.findAllByPaginate(page).then (forums) ->

                $scope.forums.push forum for forum in forums

                $scope.busy = false

                page++

    ]

