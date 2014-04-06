define ['app', 'Forum'], (app) ->

    app.register.controller 'ForumManagementController', ['$rootScope', '$scope', '$modal', 'Forum', ($rootScope, $scope, $modal, Forum) ->

        $rootScope.pageTitle = "Admin Console"
        $scope.forums = []

        forumModal = null
        page = 1

        $scope.showForumModal = (forum, mode) ->

            $scope.mode = mode

            if $scope.mode == 'edit' or $scope.mode == 'delete'

                $scope.forum = angular.copy(forum)
                
            else if $scope.mode == 'create'

                $scope.forum = Forum.create()

            if not forumModal

                forumModal = $modal
                        show: false
                        scope: $scope
                        template: window.assets.template.concat('pages/admin/components/forum-modal.html')

            forumModal.$promise.then () ->

                forumModal.show()

        $scope.nextPage = () ->

            $scope.budy = true

            Forum.findAllByPaginate(page).then (forums) ->

                if forums

                    $scope.forums.push forum for forum in forums

                    page++

                $scope.budy = false

        $scope.create = (forum) ->

            forum.save()
            .then (forum) ->

                $scope.forums.push forum

                forumModal.hide() if forumModal

        $scope.update = (forum) ->

            forum.update()
            .then (forum) ->

                async.each $scope.forums

                , (item, callback) ->

                    forum.copyDataToInstance item if item.id == forum.id
                    callback(null)

                , () ->

                    forumModal.hide() if forumModal

        $scope.destroy = (forum) ->

            forum.destroy()

            .then (forum) ->

                async.filter $scope.forums

                , (item, callback) ->

                    if item.id == forum.id then callback false else callback true

                , (results) ->

                    $scope.forums = results
                    forumModal.hide() if forumModal

    ]