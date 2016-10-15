app = angular.module 'thms.services'

app.factory 'Config', [
    '$rootScope', '$http', '$q', ($rootScope, $http, $q) ->
        new class Config
            constructor: ->
                console.log 'Config Service Starting'
]