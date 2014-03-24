define ['angularAMD'], (angularAMD) ->

    app = angular.module 'webapp', ['ngRoute', 'route-segment', 'view-segment', 'ngAnimate', 'mgcrea.ngStrap']

    app.config ['$routeSegmentProvider', '$locationProvider', ($routeSegmentProvider, $locationProvider, $q) ->

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

        $routeSegmentProvider
            .when('/',             'main')
            .when('/register',     'register')
            .when('/login',        'login')
            .segment('main',        main)
            .segment('register',    register)
            .segment('login',       login)

    ]

    angularAMD.bootstrap(app)

    angularAMD.processQueue()

    return app
