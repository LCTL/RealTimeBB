define ['app'], (app) ->

    app.register.directive 'markdown', () ->

        restrict: 'A'

        link: (scope, element, attrs) ->

            scope.$watch attrs.markdown, (newValue, oldValue) ->

                htmlText = markdown.toHTML newValue
                element.html htmlText