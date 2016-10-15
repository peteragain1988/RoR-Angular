app = angular.module 'thms.modules.venue'

class FacilitiesIndexCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'facilities', '$state', '$modal', '$humane'

    # initialize the controller
    initialize: ->
        @$scope.data = @facilities

    newFacility: ->
        @modal = @$modal.open
            templateUrl: 'facilities/new.html',
            windowClass: 'effect-8'
            resolve:
                facility: [
                    'Facility', (Facility) ->
                        new Facility()
                ]
            controller: [
                '$scope', 'facility', '$humane', '$state', ($scope, facility, $humane, $state) ->
                    $scope.facility = facility
                    $scope.save = () ->
                        facility.create()
                        .then (result) ->
                            $humane.successShort 'Facility Created'
                            $state.go "authenticated.main.facility.view", facility_id: facility.id
                            $scope.$close()
                        .catch (error) ->
                            $humane.errorShort 'Error Creating Facility'

            ]


    # filter on facility name, type, and company name
    updateFilter: ->
        @$scope.filterModel =
            name: @$scope.filterValue
            currentLeaseeName: @$scope.filterValue