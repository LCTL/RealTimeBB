define ['app', 'Forum'], (app) ->

    app.register.controller 'ForumManagementController', ['$rootScope', '$scope', '$modal', 'Forum', ($rootScope, $scope, $modal, Forum) ->

        $scope.forums = []

        allForumLoaded = false
        forumModal = null
        page = 1
        limit = 100
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

            if not $scope.busy and not allForumLoaded

                $scope.busy = true

                Forum.findAllByPaginate(page, limit).then (forums) ->

                    if forums

                        $scope.forums.push forum for forum in forums

                        page++

                    allForumLoaded = _.isEmpty forums or forums.length < limit

                    $scope.busy = false

        $scope.create = (forum) ->

            forum.save()

            .then (forumData) ->

                forumModal.hide() if forumModal

            , (err) ->

                alert err

        $scope.update = (forum) ->

            forum.update()

            .then (forumData) ->

                forumModal.hide() if forumModal

            , (err) ->

                alert err

        $scope.destroy = (forum) ->

            forum.destroy()

            .then (forumData) ->

                forumModal.hide() if forumModal

            , (err) ->

                alert err

        listenerCallbacks.push $scope.$on 'Forum', (event, message) ->

            if message.action is 'create'

                async.some $scope.forums

                , (forum, callback) ->

                    if forum.id is message.data.id then callback true else callback false

                , (result) ->

                    if not result

                        $scope.forums.push Forum.create message.data

                        $scope.$digest()

            else if message.action is 'destroy'

                async.filter $scope.forums

                , (forum, callback) ->

                    if forum.id is message.data.id then callback false else callback true

                , (results) ->

                    $scope.forums = results

                    $scope.$digest()

        listenerCallbacks.push $scope.$on '$destroy', () ->

            forum.releaseReference() for forum in $scope.forums

            $scope.forums = null

            listenerCallback() for listenerCallback in listenerCallbacks

    ]