require.config

    baseUrl: window.assets.js.path

    paths:

        'angularAMD':           'vendor/angularAMD'
        'ngload':               'vendor/ngload'

        'app':                  'app'

        'CommunicationService': 'services/CommunicationService'
        'UserService':          'services/UserService'
        'ResourceFactory':      'services/ResourceFactory'

        'MainController':       'controllers/MainController'
        'RegisterController':   'controllers/RegisterController'
        'LoginController':      'controllers/LoginController'
        'AdminFrameController': 'controllers/AdminFrameController'
        'ForumManagementController': 'controllers/ForumManagementController'

    shim:

        'ngload':               
            deps: ['angularAMD']

    deps: ['app']