app = angular.module 'thms.directives'

app.directive 'toUnix', [ ->
        require: 'ngModel'
        link: (scope, el, attr, ngModel) ->

            ngModel.$parsers.push (val) ->
                new Date(val).getTime() / 1000

            ngModel.$formatters.push (originalVal) ->
                new Date(originalVal * 1000)
]