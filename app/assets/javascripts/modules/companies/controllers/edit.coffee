app = angular.module 'thms.modules.venue'

class CompanyEditCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$modal', 'company', '$humane', 'employees'

    # initialize the controller
    initialize: ->
        @$scope.company = angular.copy(@company)
        @$scope.company.manager_id = @$scope.company.manager.id if @$scope.company.manager
        @$scope.employees = @employees

    save: ->
        # modified data is in $scope.company, pass it as an option to the save func
        @company.save(@$scope.company.data)
        .then (result) =>
            @$humane.successShort 'Company Updated'
            @$scope.$close(result)
        .catch (error) =>
            @$humane.stickyError 'Error Updating Company'