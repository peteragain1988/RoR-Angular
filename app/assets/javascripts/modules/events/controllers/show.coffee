app = angular.module 'thms.modules.venue'

class EventShowCtrl extends BaseCtrl
  @register app

  @inject '$scope', 'event', 'dates', '$state', '$modal'

  # initialize the controller
  initialize: ->
    @$scope.event = @event
    @$scope.dates = @dates
#        @$scope.leases = @leases

  editEvent: ->
    @modal = @$modal.open
      templateUrl: 'events/edit.html',
      windowClass: 'effect-8'
      resolve:
        event: [
          'Events', '$stateParams', (Events, $stateParams) ->
            Events.view($stateParams.event_id)
        ]
      controller: 'EventEditCtrl'

    # Modal Closed Handler
    @modal.result
    .then (result) =>
      @$scope.event.data = result.data
    .catch (error) ->
      console.log error

  newEventDate: ->
    @modal = @$modal.open
      templateUrl: 'events/add_date.html'
      windowClass: 'effect-8'
#            resolve:
#                companies: [
#                    'Companies', (Companies) ->
#                        Companies.sync()
#                ],
#                facilities:
#                # Injecting undefined as same controller is used in more than one place
#                # and we only need to choose facilities here, as we already have a company
#                    () -> undefined

      controller: 'NewEventDateCtrl'
    # Modal Closed Handler
    @modal.result
    .then (result) ->
      console.log result

  editDate: (date) ->
    modal = @$modal.open
      templateUrl: 'events/edit_date.html'
      windowClass: 'effect-8'
      controller: [
        '$scope', '$humane', '$window', '$timeout', ($scope, $humane, $window, $timeout) ->
          $scope.date = angular.copy date;

          $scope.save = ->
            $scope.buttonText = 'Saving...'
            $scope.loading = true
            date.save($scope.date.data, $scope.$files)
            .then (result) =>
              $humane.stickySuccess 'Event Saved'
              $scope.$close(result)
            .catch (error) =>
              $humane.stickyError 'Error Saving Event'
              $scope.loading = false
              $scope.buttonText = 'Save Changes'

          $scope.onFileSelect = (files, field) ->
            console.log 'foo'
            _.each files, (file) =>
              reader = new FileReader()
              # Once file reader has converted binary to base64 fire
              reader.onload = (event) =>
                $timeout =>
                  $scope.date.data[field] = event.target.result
                  $scope.date.data['delete_' + field] = undefined
                , 0

              reader.readAsDataURL file

          $scope.removeAttachment = (field) ->
            $scope.date.data['delete_' + field] = true
            $scope.date.data[field] = ''

          $scope.getImage = (src) ->
            if src is ''
              '//:0'
            else
              src

          $scope.openUrl = (url) ->
            $window.open url, '_blank'

      ]

  releaseDate: (date) ->
    @$state.go 'authenticated.main.event.view.release', {date_id: date.data.id}