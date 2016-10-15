app = angular.module 'thms.modules.venue'

class EditFacilityLeaseCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$humane', 'facilities', 'companies', 'lease'

    # initialize the controller
    initialize: ->
        @$scope.facilities = @facilities if @facilities
        @$scope.companies = @companies if @companies
        @$scope.lease = @lease

    save: ->
        @$scope.lease.save()
        .then (result) =>
            @$humane.stickySuccess 'Lease Saved'
            @$scope.$close(result)
        .catch (error) =>
            @$humane.stickyError 'Error Saving Lease'