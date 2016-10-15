app = angular.module 'thms.modules.venue'

class NewEmployeeCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'Auth', '$state', 'roles', '$log', 'Employee', 'classes', 'states', 'departments', 'managers', '$humane'

    initialize: ->
        @$scope.roles = angular.copy(@roles)
        @$scope.classes = angular.copy(@classes)
        @$scope.states = angular.copy(@states)
        @$scope.departments = angular.copy(@departments)
        @$scope.managers = angular.copy(@managers)
        @$scope.employee =
            permission: 'standardUser?'
        @$state.go 'authenticated.main.employee.add.new.basic'

    updatePermissions: (model) ->
        model.permissions =
            'canLogin?': true
        model.permissions[model.permission] = true if model.permission

    saveEmployee: (model) ->
        @$scope.updatePermissions(model)
        @$scope.savingEmployee = true

        model.companyId = @Auth.currentUser.company.id
        newEmployee = new @Employee(model)
        newEmployee.company_id = @Auth.currentUser.company.id
        newEmployee.save()
        .then (data) =>
            @$log.log data
            @$state.go 'authenticated.main.employee.index'
        .catch (error) =>
#            todo: error should be more describable than "Unprocessable Entity"
            @$humane.error('Email ' + error.data.email[0]) if error.data && error.data.email && error.data.email[0]
            @$scope.savingEmployee = false