app = angular.module 'thms.modules.venue'

class EmployeesIndexCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'Auth', 'data', '$state', '$modal', 'Employee', '$humane'

    Auth = {}
    # initialize the controller
    initialize: ->
        @$scope.data = @data
        Auth = @Auth

    editEmployee: (id) ->
        @modal = @$modal.open
            templateUrl: 'employees/_edit_employee.html'
            windowClass: 'effect-8'
            resolve:
                employee: [
                    'Employee', (Employee) ->
                        Employee.get({'companyId': Auth.currentUser.company.id, 'id': id})
                ],
                roles: [
                    'Roles', (Roles) ->
                        Roles.get();
                ],
                classes: [
                    'Classes', (Classes) ->
                        Classes.get()
                ],
                departments: [
                    'Department', 'Auth', (Department, Auth) ->
                        Department.get({'companyId': Auth.currentUser.company.id})
                ],
                states: [
                    'States', (States) ->
                        States.get()
                ],
                managers: [
                    'Auth', 'Employee', (Auth, Employee) ->
                        Employee.get({'companyId': Auth.currentUser.company.id})
                ]
            controller: 'EditEmployeeCtrl'

        @modal.result
        .then () =>
            @Employee.get({'companyId': Auth.currentUser.company.id})
            .then (data) =>
                @$scope.data = data
        .catch (error) =>
            console.log error