app = angular.module 'thms.directives'

app.directive 'fileUpload', [
    '$state',   ($state) ->
        restrict: 'E',
        scope: {},
        templateUrl: 'directives/fileUpload.html',
        controller: [
            '$scope', '$element', '$attrs', '$timeout', ($scope, $element, $attrs, $timeout) ->

                $scope.accept = ->
                    $attrs['accept']

                $scope.emptyTitle = ->
                    $attrs['emptyTitle']

                $scope.openUpFileDialog = ->
                    $timeout ->
                        $element.find('input').click()
                    , 0

                $scope.remove = ->
                    console.log 'Remove Clicked'

#                $scope.onFileSelect = (files) ->
#                    console.log files

        ]
]