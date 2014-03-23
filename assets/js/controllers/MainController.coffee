define ['app', 'CommunicationService'], (app) ->

    app.register.controller 'MainController', ['$rootScope', '$scope', 'CommunicationService', ($rootScope, $scope, communicationService) ->

        $rootScope.pageTitle = "RealTimeBB"

        communicationService.get('/forum').then (forums) ->

            $scope.forums = forums

        communicationService.addListener 'message', null, (message) ->

            console.dir message

    ]

