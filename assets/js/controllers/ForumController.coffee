define ['app', 'Forum', 'Topic'], (app) ->

    app.register.controller 'ForumController', ['$rootScope', '$scope', '$routeParams', '$location', '$modal', 'Forum', 'Topic', ($rootScope, $scope, $routeParams, $location, $modal, Forum, Topic) ->

        $rootScope.pageTitle = "Admin Console"

        $scope.forum = null

        newTopicModal = null

        Forum.findById($routeParams.id).then (forum) ->

            $scope.forum = forum

            if forum 

                forum.fetchMoreTopics()

        $scope.showNewTopicModal = () ->

            $scope.topic = Topic.create()
            $scope.topic.forumId = $scope.forum.id

            if not newTopicModal

                newTopicModal = $modal
                    show: false
                    scope: $scope
                    template: window.assets.template.concat('components/new-topic-modal.html')

            newTopicModal.$promise.then () ->

                newTopicModal.show()

        $scope.createTopic = (topic) ->

            topic.save().then (topic) ->

                newTopicModal.hide()

                $location.path "/topic/#{topic.id}"

    ]