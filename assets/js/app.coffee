define ['angularAMD', 'classes/CommunicationService', 'classes/UserService', 'classes/RouteRestrictionServiceProvider'], (angularAMD, CommunicationService, UserService, RouteRestrictionServiceProvider) ->

    app = angular.module 'webapp', ['ngRoute', 'route-segment', 'view-segment', 'ngAnimate', 'mgcrea.ngStrap', 'infinite-scroll', 'ngProgress', 'angularMoment']

    app.value 'socket.io', window.io
    app.value 'csrf', window.csrf

    app.provider 'RouteRestrictionService', RouteRestrictionServiceProvider
    app.service 'CommunicationService', CommunicationService
    app.service 'UserService', UserService

    app.config ['$routeProvider',  '$routeSegmentProvider', '$locationProvider', '$injector', 'RouteRestrictionServiceProvider', ($routeProvider, $routeSegmentProvider, $locationProvider, $injector, routeRestrictionServiceProvider) ->

        $locationProvider.html5Mode(true).hashPrefix('!')

        $routeSegmentProvider.options.autoLoadTemplates = true
        
        main = angularAMD.route
            templateUrl: window.assets.template.concat('pages/main.html')
            controller: 'MainController'

        forum = angularAMD.route
            templateUrl: window.assets.template.concat('pages/forum.html')
            controller: 'ForumController'

        topic = angularAMD.route
            templateUrl: window.assets.template.concat('pages/topic.html')
            controller: 'TopicController'

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
            .when('/forum/:id',                     'forum')
            .when('/topic/:id',                     'topic')
            .when('/register',                      'register')
            .when('/login',                         'login')
            .when('/admin',                         'admin')
            .when('/admin/forum-management',        'admin.forum')
            .when('/admin/user-management',         'admin.user')
            .segment('main',                        main)
            .segment('forum',                       forum)
            .segment('topic',                       topic)
            .segment('register',                    register)
            .segment('login',                       login)
            .segment('admin',                       admin)

        $routeSegmentProvider.within('admin')
            .segment('forum', forumManagement)
            .segment('user', userManagement)

        $routeProvider.otherwise redirectTo: '/'

        routeRestrictionServiceProvider.loginPage = '/login'
        routeRestrictionServiceProvider.restricts.push 
            segment: 'admin'
            roles: ['admin']

    ]
    
    app.factory 'promiseTask', ['$q', ($q) ->

        (task) ->

            deferred = $q.defer()

            task deferred

            deferred.promise

    ]

    app.run ['$rootScope', '$location', 'ngProgress', 'UserService', 'RouteRestrictionService', ($rootScope, $location, ngProgress, userService, routeRestrictionService) ->

        $rootScope.navbarTemplateUrl = window.assets.template.concat('components/navbar.html')
        
        $rootScope.logout = () ->

            userService.logout().then () ->

                $location.path '/'

        $rootScope.toLoginPage = () ->

            routeRestrictionService.toLoginPage()

        if window.user

            userService.setCurrentUser angular.fromJson window.user

        $rootScope.$on '$routeChangeStart', (event, current, previous) ->

            ngProgress.start()

        $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->

            ngProgress.complete()


    ]  

    angularAMD.bootstrap(app)

    return app