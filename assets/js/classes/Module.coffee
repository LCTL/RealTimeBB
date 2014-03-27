define [], () ->

    class Module

        @extend: (obj) ->

            for key, value of obj

                @[key] = value

        @include: (obj) ->

            for key, value of obj

                @::[key] = value