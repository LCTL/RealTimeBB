require.config

    baseUrl: window.assets.js.path

    paths:

        'angularAMD':           'vendor/angularAMD'
        'ngload':               'vendor/ngload'

        'app':                  'app'

        'CommunicationService': 'services/CommunicationService'
        'UserService':          'services/UserService'

        'MainController':       'controllers/MainController'
        'RegisterController':   'controllers/RegisterController'
        'LoginController':      'controllers/LoginController'

    shim:

        'ngload':               
            deps: ['angularAMD']

    deps: ['app']