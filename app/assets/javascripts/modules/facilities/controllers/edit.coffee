app = angular.module 'thms.modules.venue'

class FacilityEditCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$state', '$humane', 'facility'

    # initialize the controller
    initialize: ->
        @$scope.facility = angular.copy(@facility)

    save: () ->
        @$scope.facility.save()
        .then (result) =>
            @$humane.stickySuccess 'Facility Saved'
            @$scope.$close(result)
        .catch (error) =>
            @$humane.stickyError 'Error Saving Facility'