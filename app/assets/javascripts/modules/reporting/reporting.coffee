app = angular.module 'thms.modules.venue'

# controllers

app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider

        .state 'authenticated.main.reporting',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.reporting.index',
            url: '/reporting'
            resolve:
                events: [
                    '$http', ($http) ->
                        $http.get('/api/v2/reporting/suite_orders')
                ]
            views:
                'content@authenticated':
                    templateUrl: 'reporting/catering/event_select.html'
                    controller: [
                        '$scope', 'events', '$modal', ($scope, events, $modal) ->
                            $scope.events = events.data

                            $scope.openSelectionModal = (date) ->
                                modal = $modal.open
                                    templateUrl: 'reporting/_modal_report_select.html'
                                    windowClass: 'effect-8 quarter'
                                    controller: [
                                        '$scope', '$state', ($scope, $state) ->
                                            $scope.data = date
                                            $scope.viewSuiteOrders = () ->
                                                $state.go 'authenticated.main.reporting.suiteOrders', {id: $scope.data.id}
                                                $scope.$close()

                                            $scope.viewGuestList = () ->
                                                $state.go 'authenticated.main.reporting.guests', {id: $scope.data.id}
                                                $scope.$close()

                                            $scope.viewCateringReport = () ->
                                                $state.go 'authenticated.main.reporting.catering', {id: $scope.data.id}
                                                $scope.$close()

                                            $scope.viewParkingReport = () ->
                                                $state.go 'authenticated.main.reporting.parking', {id: $scope.data.id}
                                                $scope.$close()

                                            $scope.viewUnConfirmedReport = () ->
                                                $state.go 'authenticated.main.reporting.unconfirmed', {id: $scope.data.id}
                                                $scope.$close()
                                    ]
                    ]

        .state 'authenticated.main.reporting.unconfirmed',
            url: '/reporting/events/dates/:id/unconfirmed'
            resolve:
                unconfirmedUsers: [
                    '$http', '$stateParams', ($http, $stateParams) ->
                        $http.get "/api/v2/reporting/dates/#{$stateParams.id}/unconfirmed"
                ]
            views:
                'content@authenticated':
                    templateUrl: 'reporting/suite_orders/unconfirmed.html'
                    controller: [
                        '$scope', 'unconfirmedUsers', ($scope, unconfirmedUsers) ->
                            $scope.data = unconfirmedUsers.data
                    ]

        .state 'authenticated.main.reporting.catering',
            url: '/reporting/events/dates/:id/catering'
            resolve:
                eventDate: [
                    '$http', '$stateParams', ($http, $stateParams) ->
                        $http.get "/api/v2/reporting/dates/#{$stateParams.id}/confirmations"
                ]
            views:
                'content@authenticated':
                    templateUrl: 'reporting/catering/view.html'
                    controller: [
                        '$scope', 'eventDate', '$window',
                        ($scope, eventDate, $window) ->
                            $scope.event = eventDate.data
                            $scope.downloadExcel = (eventDateId) ->
                                $window.open "/api/v2/reporting/dates/#{eventDateId}/catering.xlsx", "_blank"
                    ]

        .state 'authenticated.main.reporting.suiteOrders',
            url: '/reporting/events/dates/:id/suites'
            resolve:
                eventDate: [
                    '$http', '$stateParams', ($http, $stateParams) ->
                        $http.get "/api/v2/reporting/dates/#{$stateParams.id}/confirmations"
                ]
            views:
                'header@authenticated':
                    template: '<h1>Suite Order Report</h1>'
                'content@authenticated':
                    templateUrl: 'reporting/suite_orders/view.html'
                    controller: [
                        '$scope', 'eventDate', '$window', ($scope, eventDate, $window) ->
                            $scope.event = eventDate.data
                            $scope.downloadExcel = (eventDateId) ->
                                $window.open "/api/v2/reporting/dates/#{eventDateId}/confirmations.xlsx", "_blank"
                    ]

        .state 'authenticated.main.reporting.guests',
            url: '/reporting/events/dates/:id/guests'
            resolve:
                eventDate: [
                    '$http', '$stateParams', ($http, $stateParams) ->
                        $http.get "/api/v2/reporting/dates/#{$stateParams.id}/confirmations"
                ]
            views:
                'header@authenticated':
                    template: '<h1>Guest Report</h1>'
                'content@authenticated':
                    templateUrl: 'reporting/guest_report.html'
                    controller: [
                        '$scope', 'eventDate', '$window', ($scope, eventDate, $window) ->
                            $scope.event = eventDate.data


                            $scope.downloadExcel = (eventDateId) ->
                                $window.open "/api/v2/reporting/dates/#{eventDateId}/confirmations.xlsx", "_blank"
                    ]
        .state 'authenticated.main.reporting.parking',
            url: '/reporting/events/dates/:id/parking'
            resolve:
                eventDate: [
                    '$http', '$stateParams', ($http, $stateParams) ->
                        $http.get "/api/v2/reporting/dates/#{$stateParams.id}/confirmations"
                ]
            views:
                'header@authenticated':
                    template: '<h1>Parking Report</h1>'
                'content@authenticated':
                    templateUrl: 'reporting/parking/index.html'
                    controller: [
                        '$scope', 'eventDate', '$modal', '$http', ($scope, eventDate, $modal, $http) ->
                            $scope.event = eventDate.data

                            $scope.updateOption = (option) ->
                                url = "/api/v2/confirmations/#{option.id}"
                                $http.put(url, option)
                                .then (result) =>
                                    console.log result
                                .catch (error) =>
                                    console.log error

                            $scope.showModal = (confirmation) ->

                                modal = $modal.open
                                    templateUrl: 'reporting/parking/_modal_allocate.html'
                                    windowClass: 'effect-10'
                                    controller: [
                                        '$scope', '$state', '$http', '$humane', '$filter',
                                        ($scope, $state, $http, $humane, $filter) ->
                                            $scope.option = angular.copy confirmation;

                                            unless $scope.option.data.parkingAllocationDate
                                                $scope.option.data.parkingAllocationDate = $filter('date')(Date.now(), 'yyyy-MM-dd')

                                            $scope.save = (option) ->

                                                url = "/api/v2/confirmations/#{option.id}"
                                                $http.put(url, option)
                                                .then (result) ->
                                                    confirmation.data = angular.copy result.data.data
                                                    $humane.stickySuccess 'Allocation Saved'
                                                    $scope.$close();
                                                .catch (error) ->
                                                    console.log error
                                    ]
                    ]
]