app = angular.module 'thms'

app.directive 'clickNext', [() ->
    restrict: 'A'
    controller: [
        '$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
            $element.click ->
                $element.next('input').click()
    ]
]