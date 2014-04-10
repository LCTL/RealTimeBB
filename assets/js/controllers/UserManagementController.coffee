define ['app', 'User'], (app) ->

    app.register.controller 'UserManagementController', ['$rootScope', '$scope', '$modal', 'User', ($rootScope, $scope, $modal, User) ->

        $scope.users = []
        $scope.user = null

        allUserLoaded = false
        userModal = null
        page = 1
        limit = 100
        listenerCallbacks = []

        $scope.showUserModal = (user, mode) ->

            $scope.mode = mode

            if $scope.mode == 'edit' or $scope.mode == 'delete'

                $scope.user = angular.copy(user)

                $scope.user.originEmail = $scope.user.email
                $scope.user.originUsername = $scope.user.username
                
            else if $scope.mode == 'create'

                $scope.user = User.create()

            $scope.user.emailAvailable = true
            $scope.user.usernameAvailable = true

            if not userModal

                userModal = $modal
                    show: false
                    scope: $scope
                    template: window.assets.template.concat('pages/admin/components/user-modal.html')

            userModal.$promise.then () ->

                userModal.show()

        $scope.nextPage = () ->

            if not $scope.busy and not allUserLoaded

                $scope.busy = true

                User.findAllByPaginate(page, limit).then (users) ->

                    if users

                        $scope.users.push user for user in users

                        page++

                    allUserLoaded = _.isEmpty users or users.length < limit

                    $scope.busy = false

        $scope.create = (user) ->

            user.save().then (userData) ->

                userModal.hide() if userModal

            , (err) ->

                alert err

        $scope.update = (user) ->

            user.update().then (userData) ->

                userModal.hide() if userModal

            , (err) ->

                alert err

        $scope.delete = (user) ->

            user.destroy().then (userData) ->

                userModal.hide() if userModal

            , (err) ->

                alert err

        listenerCallbacks.push $scope.$on 'User', (event, message) ->

            if message.action is 'create' and message.data.email

                async.some $scope.users

                , (user, callback) ->

                    if user.id is message.data.id

                        callback true

                    else 

                        callback false

                , (result) ->

                    if not result

                        $scope.users.push User.create message.data

                        $scope.$digest()

            else if message.action is 'destroy'

                async.filter $scope.users

                , (user, callback) ->

                    if user.id is message.data.id then callback false else callback true

                , (results) ->

                    $scope.users = results

                    $scope.$digest()

        listenerCallbacks.push $scope.$watch 'user.username', (newValue, oldValue) ->

            if $scope.user

                if $scope.user.originUsername == newValue

                    $scope.user.usernameAvailable = true

                else

                    $scope.user.isUsernameAvailable()

        listenerCallbacks.push $scope.$watch 'user.email', (newValue, oldValue) ->

            if $scope.user

                if $scope.user.originEmail == newValue

                    $scope.user.emailAvailable = true

                else

                    $scope.user.isEmailAvailable()

        listenerCallbacks.push $scope.$on '$destroy', () ->

            user.releaseReference() for user in $scope.users

            $scope.user.releaseReference() if $scope.user

            $scope.users = null

            listenerCallback() for listenerCallback in listenerCallbacks

    ]

