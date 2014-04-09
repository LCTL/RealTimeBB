define ['app', 'User'], (app) ->

    app.register.controller 'UserManagementController', ['$rootScope', '$scope', '$modal', 'User', ($rootScope, $scope, $modal, User) ->

        $scope.users = []
        $scope.user = null

        userModal = null
        page = 1
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

            $scope.busy = true

            User.findAllByPaginate(page).then (users) ->

                if users

                    $scope.users.push user for user in users

                    page++

                $scope.busy = false

        $scope.create = (user) ->

            user.save().then (user) ->

                $scope.users.push user

                userModal.hide() if userModal

        $scope.update = (user) ->

            user.update().then (user) ->

                async.each $scope.users

                , (item, callback) ->

                    if item.id == user.id

                        console.dir item

                        user.copyDataToInstance item

                    callback(null)

                , () ->

                    userModal.hide() if userModal

        $scope.delete = (user) ->

            user.destroy().then (user) ->

                async.filter $scope.users

                , (item, callback) ->

                    if item.id is user.id

                        user.releaseReference()

                        callback false

                    else

                        callback true

                , (results) ->

                     $scope.users = results

                     userModal.hide() if userModal


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

