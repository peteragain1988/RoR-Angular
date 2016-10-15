app = angular.module 'thms.services'

app.factory 'ChangeRequest', ['$http', '$q', ($http, $q) ->
    class ChangeRequest
        send: (comment) ->
            defer = $q.defer()
            request = $http.post '/api/v2/employees/report_incorrect_data', { comment: comment }
            request.then (result) =>
                defer.resolve result.data.message

            return defer.promise
    new ChangeRequest
]