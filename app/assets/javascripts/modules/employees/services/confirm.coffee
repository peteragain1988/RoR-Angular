app = angular.module 'thms.services'

app.factory 'Confirm', ['$http', '$q', ($http, $q) ->
    class Confirm
        send: (password, token) ->
            defer = $q.defer()
            request = $http.post '/api/v2/employees/password_reset', { token: token, password: password }
            request.then (result) =>
                defer.resolve result.data.message

            return defer.promise
    new Confirm
]