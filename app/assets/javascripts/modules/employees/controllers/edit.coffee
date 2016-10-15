app = angular.module 'thms.modules.venue'

class EditEmployeeCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'Auth', '$state', 'roles', '$log', 'employee', 'states', 'departments', 'classes', 'managers', '$humane', '$modal', 'ChangeRequest'

    initialize: ->
        @$scope.roles = angular.copy(@roles)
        @$scope.states = angular.copy(@states)
        @$scope.departments = angular.copy(@departments)
        @$scope.classes = angular.copy(@classes)
        @$scope.managers = angular.copy(@managers)

#        format permissions
        employee = @employee
        angular.forEach employee.permissions, (value, permission) ->
            employee.permission = permission if value && permission != 'canLogin?'
        @$scope.employee = employee
        @$scope.employee.canLogin = employee.permissions['canLogin?']
        @$scope.employee.permission = 'standard_user?' if !@$scope.employee.permission

#        set non-changeable data (managers, company name, department) on "edit current user" page
        $scope = @$scope
        angular.forEach @$scope.departments, (department) ->
            $scope.department = department if department.id == $scope.employee.departmentId
        angular.forEach @$scope.managers, (manager) ->
            $scope.firstManager = manager if manager.id == $scope.employee.firstManager
            $scope.secondManager = manager if manager.id == $scope.employee.secondManager
            $scope.thirdManager = manager if manager.id == $scope.employee.thirdManager
        angular.forEach @$scope.classes, (klass) ->
            $scope.klass = klass if klass.value == $scope.employee.profileAttributes.klass
        angular.forEach @$scope.roles, (role) ->
            $scope.role = role if role.value == $scope.employee.permission

    updatePermissions: (model) ->
        model.permissions =
            'can_login?': model.canLogin
        model.permissions[model.permission] = true

    saveEmployee: (model) ->
        employee = angular.copy model

        employee.profile_attributes = employee.profile
        delete employee.profile

        employee.companyId = @Auth.currentUser.company.id

        @$scope.updatePermissions(employee)
        employee.save()
        .then () =>
            @$humane.successShort 'Employee Saved'
            @$scope.$close() if @$scope.$close
        .catch (error) =>
            @$humane.errorShort 'Error Saving Employee'
            @$scope.$close() if @$scope.$close

    showReportModal: () ->
        @$scope.modal = @$modal.open
            templateUrl: 'employees/change_request.html'
            windowClass: 'effect-8'
            scope: @$scope

    changeRequest: (change) ->
        @ChangeRequest.send change
        .then (message) =>
            @$humane.successShort message
            @$scope.modal.close()
