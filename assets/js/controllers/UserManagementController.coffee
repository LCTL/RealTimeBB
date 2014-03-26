define ['app', 'User'], (app) ->

    app.register.controller 'UserManagementController', ['$rootScope', '$scope', '$modal', 'User', ($rootScope, $scope, $modal, User) ->

        $scope.users = []

        userModal = null
        page = 1

        $scope.showUserModal = (user, mode) ->

            $scope.mode = mode

            if $scope.mode == 'edit' or $scope.mode == 'delete'

                $scope.user = angular.copy(user)
                
            else if $scope.mode == 'create'

                $scope.user = User.create()

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

    ]

