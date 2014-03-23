define ['angularAMD'], (angularAMD) ->

    app = angular.module 'webapp', ['ngRoute', 'ngAnimate', 'mgcrea.ngStrap']

    app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

        $locationProvider.html5Mode(true).hashPrefix('!')

        main = angularAMD.route
            templateUrl: window.assets.template.concat('pages/main.html')
            controller: 'MainController'

        register = angularAMD.route
            templateUrl: window.assets.template.concat('pages/register.html')
            controller: 'RegisterController'

        login = angularAMD.route
            templateUrl: window.assets.template.concat('pages/login.html')
            controller: 'LoginController'

        $routeProvider
        .when('/', main)
        .when('/register', register)
        .when('/login', login)
        .otherwise(redirectTo: '/')

    ]

    angularAMD.bootstrap(app)

    angularAMD.processQueue()

    return app
