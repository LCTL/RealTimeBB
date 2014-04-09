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

        $scope.$on 'Forum', (event, message) ->

            if message.action is 'create'

                $scope.forums.push Forum.create message.data
                $scope.$digest()

            else if message.action is 'destroy'

                async.filter $scope.forums

                , (forum, callback) ->

                    if forum.id is message.data.id then callback false else callback true

                , (results) ->

                    $scope.forums = results
                    $scope.$digest()

        $scope.$on '$destroy', () ->

            forum.releaseReference() for forum in $scope.forums

            $scope.forums = null

    ]

