define ['angularAMD', 'classes/CommunicationService', 'classes/UserService'], (angularAMD, CommunicationService, UserService) ->

    app = angular.module 'webapp', ['ngRoute', 'route-segment', 'view-segment', 'ngAnimate', 'mgcrea.ngStrap', 'infinite-scroll']

    app.config ['$routeProvider',  '$routeSegmentProvider', '$locationProvider', '$injector', ($routeProvider, $routeSegmentProvider, $locationProvider, $injector) ->

        $locationProvider.html5Mode(true).hashPrefix('!')

        $routeSegmentProvider.options.autoLoadTemplates = true
        
        main = angularAMD.route
            templateUrl: window.assets.template.concat('pages/main.html')
            controller: 'MainController'

        register = angularAMD.route
            templateUrl: window.assets.template.concat('pages/register.html')
            controller: 'RegisterController'

        login = angularAMD.route
            templateUrl: window.assets.template.concat('pages/login.html')
            controller: 'LoginController'

        admin = angularAMD.route
            templateUrl: window.assets.template.concat('pages/admin/frame.html')
            controller: 'AdminFrameController'

        forumManagement = angularAMD.route
            templateUrl: window.assets.template.concat('pages/admin/segments/forum-management.html')
            controller: 'ForumManagementController'

        userManagement = angularAMD.route
            templateUrl: window.assets.template.concat('pages/admin/segments/user-management.html')
            controller: 'UserManagementController'

        $routeSegmentProvider
            .when('/',                              'main')
            .when('/register',                      'register')
            .when('/login',                         'login')
            .when('/admin',                         'admin')
            .when('/admin/forum-management',        'admin.forum')
            .when('/admin/user-management',         'admin.user')
            .segment('main',                        main)
            .segment('register',                    register)
            .segment('login',                       login)
            .segment('admin',                       admin)

        $routeSegmentProvider.within('admin')
            .segment('forum', forumManagement)
            .segment('user', userManagement)

        $routeProvider.otherwise redirectTo: '/'

    ]

    app.value 'socket.io', window.io
    app.value 'csrf', window.csrf

    app.service 'CommunicationService', CommunicationService
    app.service 'UserService', UserService
    app.factory 'promiseTask', ['$q', ($q) ->

        (task) ->

            deferred = $q.defer()

            task deferred

            deferred.promise

    ]

    app.run ['$rootScope', 'UserService', ($rootScope, userService) ->

        $rootScope.navbarTemplateUrl = window.assets.template.concat('components/navbar.html')
        
        $rootScope.logout = () ->

            userService.logout()

        if window.user

            userService.setCurrentUser window.user

    ]  

    angularAMD.bootstrap(app)

    return app