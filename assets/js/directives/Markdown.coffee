define ['app'], (app) ->

    app.register.directive 'markdown', () ->

        restrict: 'A'

        link: (scope, element, attrs) ->

            scope.$watch attrs.markdown, (newValue, oldValue) ->

                htmlText = if newValue then markdown.toHTML newValue else ''
                element.html htmlText