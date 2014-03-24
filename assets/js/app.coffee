define ['angularAMD'], (angularAMD) ->

    app = angular.module 'webapp', ['ngRoute', 'route-segment', 'view-segment', 'ngAnimate', 'mgcrea.ngStrap']

    app.config ['$routeProvider',  '$routeSegmentProvider', '$locationProvider', ($routeProvider, $routeSegmentProvider, $locationProvider) ->

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

        $routeSegmentProvider
            .when('/',                              'main')
            .when('/register',                      'register')
            .when('/login',                         'login')
            .when('/admin',                         'admin')
            .when('/admin/forum-management',        'admin.forum')
            .segment('main',                        main)
            .segment('register',                    register)
            .segment('login',                       login)
            .segment('admin',                       admin)

        $routeSegmentProvider.within('admin').segment('forum', forumManagement)

        $routeProvider.otherwise redirectTo: '/'

    ]

    app.run ['$rootScope', ($rootScope) ->

        $rootScope.navbarTemplateUrl = window.assets.template.concat('components/navbar.html')
        
    ]    

    requirejs ['UserService'], () ->

        #injector = angular.injector ['webapp']

        ### Cannot inject UserService
        injector.invoke ['$rootScope', 'UserService', ($rootScope, userService) ->

            $rootScope.logout = () ->

                userService.logout()

            userService.getCurrentUser().then (user) ->

                userService.setCurrentUser user

        ]
        ###

    angularAMD.bootstrap(app)

    angularAMD.processQueue()

    return app