define ['app'], (app) ->

    app.register.controller 'AdminFrameController', ['$rootScope', '$scope', '$routeSegment', '$translate', ($rootScope, $scope, $routeSegment, $translate) ->

        $translate('ADMIN.TITLE').then (title) ->

            $translate('COMMONS.INNER_PAGE_TITLE', title: title).then (pageTitle) ->

                $rootScope.pageTitle = pageTitle

        $scope.$routeSegment = $routeSegment

    ]