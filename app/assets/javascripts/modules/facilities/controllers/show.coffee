app = angular.module 'thms.modules.venue'

class FacilityShowCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'facility', '$state', '$modal'

    # initialize the controller
    initialize: ->
        @$scope.facility = @facility

    editFacility: ->
        @modal = @$modal.open
            templateUrl: 'facilities/edit.html'
            windowClass: 'effect-8'
            controller: 'FacilityEditCtrl'
            resolve:
                facility: => @$scope.facility
        # Modal Closed Handler
        @modal.result
        .then (result) =>
            @$scope.facility.get()
        .catch (error) ->
            console.log error

    editLease: (lease) ->
        @modal = @$modal.open
            templateUrl: 'facilities/edit_lease.html'
            windowClass: 'effect-8'
            resolve:
                companies: [
                    'Companies', (Companies) ->
                        Companies.sync()
                ],
                facilities:
                    () -> undefined
                lease: [
                    'FacilityLease', '$stateParams', (FacilityLease, $stateParams) ->
                        FacilityLease.get id: lease.id, facilityId: $stateParams.facility_id
                ]

            controller: 'EditFacilityLeaseCtrl'
        @modal.result
        .then (result) =>
            @$scope.facility.get()

    newLease: ->
        @modal = @$modal.open
            templateUrl: 'facilities/new_lease.html'
            windowClass: 'effect-8'
            resolve:
                companies: [
                    'Companies', (Companies) ->
                        Companies.sync()
                ],
                facilities:
                # Injecting undefined as same controller is used in more than one place
                # and we only need to choose facilities here, as we already have a company
                    () -> undefined
                lease: [
                    'FacilityLease', '$stateParams', (FacilityLease, $stateParams) =>
                        new FacilityLease facility_id: $stateParams.facility_id, is_enabled: true
                ]

            controller: 'EditFacilityLeaseCtrl'
        # Modal Closed Handler
        @modal.result
        .then (result) =>
            @$scope.facility.get()