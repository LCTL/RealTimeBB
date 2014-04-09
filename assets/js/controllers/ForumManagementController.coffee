define ['app', 'Forum'], (app) ->

    app.register.controller 'ForumManagementController', ['$rootScope', '$scope', '$modal', 'Forum', ($rootScope, $scope, $modal, Forum) ->

        $rootScope.pageTitle = "Admin Console"
        $scope.forums = []

        forumModal = null
        page = 1
        listenerCallbacks = []

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
            .then (forumData) ->

                $scope.forums.push Forum.create forum

                forumModal.hide() if forumModal

        $scope.update = (forum) ->

            forum.update()
            .then (forumData) ->

                async.each $scope.forums

                , (forum, callback) ->

                    forum.copyDataToInstance forumData if forum.id == forumData.id
                    callback(null)

                , () ->

                    forumModal.hide() if forumModal

        $scope.destroy = (forum) ->

            forum.destroy()

            .then (forumData) ->

                async.filter $scope.forums

                , (forum, callback) ->

                    if forum.id == forumData.id 

                        forum.releaseReference()

                        callback false 

                    else 

                        callback true

                , (results) ->

                    $scope.forums = results
                    forumModal.hide() if forumModal

        listenerCallbacks.push $scope.$on '$destroy', () ->

            forum.releaseReference() for forum in $scope.forums

            $scope.forums = null

            listenerCallback() for listenerCallback in listenerCallbacks

    ]