define ['app', 'Forum', 'Topic'], (app) ->

    app.register.controller 'ForumController', [
            '$rootScope', '$scope', '$routeParams', '$location', '$modal', '$alert', 
            '$sce', '$timeout', '$translate', 'UserService', 'Forum', 'Topic', 
            ($rootScope, $scope, $routeParams, $location, $modal, $alert, $sce, $timeout, $translate, userService, Forum, Topic) ->

                $scope.forum = null

                newTopicModal = null
                loginAlert = null

                Forum.findById($routeParams.id).then (forum) ->

                    $translate('COMMONS.INNER_PAGE_TITLE', title: forum.name).then (pageTitle) ->

                        $rootScope.pageTitle = pageTitle

                    $scope.forum = forum

                    if forum 

                        forum.fetchMoreTopics()

                $scope.showNewTopicModal = () ->

                    if userService.isLoggedIn()

                        $scope.topic = Topic.create()
                        $scope.topic.forumId = $scope.forum.id

                        if not newTopicModal

                            newTopicModal = $modal
                                show: false
                                scope: $scope
                                template: window.assets.template.concat('components/new-topic-modal.html')

                        newTopicModal.$promise.then () ->

                            newTopicModal.show()

                    else 

                        if not loginAlert

                            loginAlert = $alert 

                                template: window.assets.template.concat('components/login-alert.html')
                                #content: $sce.trustAsHtml 'Please click <a href="#" ng-click="toLoginPage()">here<a/> to login.'
                                type: 'warning'
                                placement: 'top'
                                show: false

                        loginAlert.$promise.then () ->

                            loginAlert.toggle()


                            ###
                            $timeout () ->

                                loginAlert.hide()

                            , 5000
                            ###

                $scope.createTopic = (topic) ->

                    topic.save().then (topic) ->

                        newTopicModal.hide()

                        $location.path "/topic/#{topic.id}"

                $scope.$on '$destroy', () ->

                    $scope.forum.releaseReference()

                    $scope.forum = null
    ]