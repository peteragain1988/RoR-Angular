app = angular.module 'thms.modules.venue'

class EventsIndexCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'events', '$state', '$modal', '$humane', '$http'

    # initialize the controller
    initialize: ->
        @$scope.data = @events

    newEvent: ->
        @modal = @$modal.open
            templateUrl: 'events/add.html',
            windowClass: 'effect-8'
            resolve:
                event: [
                    'Event', '$q', (Event, $q) ->
                        new Event()
                ]
            controller: 'EventEditCtrl'

        # Modal Closed Handler
        @modal.result
        .then (result) =>
#            @events.addElement result
            @$state.go 'authenticated.main.event.view', {event_id: result.data.id}
        .catch (error) ->
            console.log error

    loadClosedEvents: ->
        @$scope.loading = true

        @$http.get '/api/v2/events?status=Closed'
        .then (results) =>
            @$scope.closed_events = results.data
            @$scope.loading = false
        .catch (error) =>
            @$humane.stickyError error

