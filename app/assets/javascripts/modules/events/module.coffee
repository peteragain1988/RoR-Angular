app = angular.module 'thms.modules.venue'

app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider

        .state 'authenticated.main.event.client',
            abstract: true,
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.event.client.index',
            url: '/my/events'
            resolve:
                inventory: [
                    '$http', ($http) ->
                        $http.get('/api/v2/my/inventory')
                ],
                upcomingEvents: [
                    '$http', ($http) ->
                        $http.get('/api/v2/my/events/upcoming')
                ]
            views:
                'header@authenticated':
                    template: '<h1>My Events</h1>'
                'content@authenticated':
                    templateProvider: [
                      'Auth', '$templateCache', (Auth, $templateCache) ->
                        return $templateCache.get('events/client_admin_index.html') if Auth.currentUser.permissions['client_admin?']
                        return $templateCache.get('events/client_user_index.html') unless Auth.currentUser.permissions['client_admin?']
                    ]
                    controller: [
                        '$scope', 'inventory', 'upcomingEvents', '$humane', '$modal', '$http', '$state', 'Tickets',
                        ($scope, inventory, upcomingEvents, $humane, $modal, $http, $state, Tickets) ->
                            $scope.data = inventory.data
                            $scope.upcomingEvents = upcomingEvents.data

                            $scope.openFile = (file) ->
                                modal = $modal.open
                                    template: "<div class='panel'><iframe src='#{file}'></iframe></div>"
                                    windowClass: 'effect-12 xxlarge xxtall'

                            $scope.confirmAttendance = (inventory) ->
                                modal = $modal.open
                                    templateUrl: 'inventory/confirm_attendance.html'

                            #TODO remove
                            # Oyster Special
                            $scope.confirmOysterSpecial = (event) ->
                                modal = $modal.open
                                    templateUrl: 'inventory/_modal_oyster_special.html'
                                    resolve:
                                        confirmation: ['$http', ($http) -> $http.get "/api/v2/confirmations/#{event.confirmation_id}" ]
                                    controller: [
                                        '$scope','$http','$humane', 'confirmation', ($scope, $http, $humane, confirmation) =>
                                            $scope.confirmation = confirmation.data

                                            $scope.confirmSpecialOffer = ->
                                                $scope.confirmation.data.oysterSpecial = true
                                                $http.put "/api/v2/confirmations/#{event.confirmation_id}", data: $scope.confirmation.data
                                                .then (results) =>
                                                    $humane.successShort 'Special Option Confirmed'
                                                    event.confirmation_data.oysterSpecial = true
                                                    $scope.$close()
                                    ]

                            $scope.releaseToTeam = ->
                                modal = $modal.open
                                    templateUrl: 'teasers/modal_release_to_team.html'

                            $scope.reconfirmOption = (event) ->
                                $http.delete "/api/v2/confirmations/#{event.confirmation_id}"
                                .success (result) ->
                                    Tickets.count = 0
                                    $state.go 'authenticated.main.inventory.confirmOptions', {id: event.id}


                            $scope.confirmGuests = (inventoryId) ->
                                modal = $modal.open
                                    templateUrl: 'inventory/_modal_guest_names.html',
                                    controller: [
                                        '$scope', 'confirmation', 'InventoryConfirmation',
                                        ($scope, confirmation, InventoryConfirmation) ->
                                            $scope.confirmation = confirmation.data

                                            if $scope.confirmation.guests.length is 0
                                            then $scope.guestList = [
                                                {name: ''}
                                            ]
                                            else $scope.guestList = $scope.confirmation.guests

                                            $scope.addNewGuestName = () ->
                                                $scope.guestList.push {name: ''}

                                            $scope.save = () ->
                                                $scope.confirmation.guests = $scope.guestList
                                                InventoryConfirmation.update $scope.confirmation
                                                .then (result) ->
                                                    $humane.stickySuccess 'Guest List Updated'
                                                    $scope.$close()
                                                .catch (error) ->
                                                    $humane.stickyError 'Error Saving Guest List'
                                                    $scope.$close()
                                    ]
                                    resolve:
                                        confirmation: [
                                            'InventoryConfirmation', (InventoryConfirmation) ->
                                                InventoryConfirmation.view(inventoryId)
                                        ]

                                    windowClass: 'effect-8'
                    ]

        .state 'authenticated.main.event',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.event.index',
            url: '/events'
            resolve:
                events: [
                    'Events', (Events) ->
                        Events.sync()
                ]
            views:
                'content@authenticated':
                    templateUrl: 'events/main.html'
                    controller: 'EventsIndexCtrl'
                'header@authenticated':
                    template: '<h1>Event Management</h1>'

        .state 'authenticated.main.event.view',
            url: '/events/:event_id'
            resolve:
                event: [
                    'Events', '$stateParams', (Events, $stateParams) ->
                        Events.view($stateParams.event_id)
                ],
                dates: [
                    'EventDates', '$stateParams', (EventDates, $stateParams) ->
                        EventDates.forEvent($stateParams.event_id)
                ]
            views:
                'content@authenticated':
                    templateUrl: 'events/view.html',
                    controller: 'EventShowCtrl'

        .state 'authenticated.main.event.view.release', {
            url: '/dates/:date_id/release',
            resolve:
                availableFacilities: [
                    'EventDates', '$stateParams', (EventDates, $stateParams) ->
                        EventDates.facilitiesForRelease($stateParams.event_id, $stateParams.date_id)
                ]
            views:
                'content@authenticated':
                    templateUrl: 'events/release.html'
                    controller: 'EventReleaseController'
        }
]