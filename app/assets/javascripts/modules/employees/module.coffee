app = angular.module 'thms'

app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider
        .state 'authenticated.main.employee',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.employee.index',
            url: '/employees'
            resolve:
                data: [
                    'Auth', 'Employee', (Auth, Employee) ->
                        Employee.get {'companyId': Auth.currentUser.company.id}
                ]
            views:
                'content@authenticated':
                    templateUrl: 'employees/main.html'
                    controller: 'EmployeesIndexCtrl'
                'header@authenticated':
                    templateUrl: 'employees/_header_main.html'

        .state 'authenticated.main.employee.add',
            url: '/employee/add',
            views:
                'content@authenticated':
                    templateUrl: 'employees/add.html'
                'header@authenticated':
                    templateUrl: 'employees/_header_add.html'

        .state 'authenticated.main.employee.add.new',
            url: '/new',
            views:
                'content@authenticated':
                    templateUrl: 'employees/_add_employee.html',
                    resolve:
                        roles: [
                            'Roles', (Roles) ->
                                Roles.get()
                        ],
                        classes: [
                            'Classes', (Classes) ->
                                Classes.get()
                        ],
                        departments: [
                            'Department', 'Auth', (Department, Auth) ->
                                Department.get {'companyId': Auth.currentUser.company.id}
                        ],
                        states: [
                            'States', (States) ->
                                States.get()
                        ],
                        managers: [
                            'Auth', 'Employee', (Auth, Employee) ->
                                Employee.get {'companyId': Auth.currentUser.company.id}
                        ]
                    controller: 'NewEmployeeCtrl'

        .state 'authenticated.main.employee.add.new.basic',
            url: '/basic',
            views:
                'steps':
                    templateUrl: 'employees/forms/basic_data.html'

        .state 'authenticated.main.employee.add.new.client',
            url: '/client',
            views:
                'steps':
                    templateUrl: 'employees/forms/client_config.html'

        .state 'authenticated.main.employee.add.new.approval',
            url: '/approval',
            views:
                'steps':
                    templateUrl: 'employees/forms/approval_path.html'

        .state 'authenticated.main.employee.me',
            url: '/profile/edit',
            views:
                'header@authenticated':
                    template: '<h1>My Profile</h1>'
                'content@authenticated':
                    templateUrl: 'employees/edit_me.html'
                    resolve:
                        roles: [
                            'Roles', (Roles) ->
                                Roles.get()
                        ]
                        classes: [
                            'Classes', (Classes) ->
                                Classes.get()
                        ],
                        departments: [
                            'Department', 'Auth', (Department, Auth) ->
                                Department.get {'companyId': Auth.currentUser.company.id}
                        ],
                        states: [
                            'States', (States) ->
                                States.get()
                        ],
                        managers: [
                            'Auth', 'Employee', (Auth, Employee) ->
                                Employee.get {'companyId': Auth.currentUser.company.id}
                        ],
                        employee: [
                            'Auth', 'Employee', (Auth, Employee) ->
                                Employee.get {'companyId': Auth.currentUser.company.id, 'id': Auth.currentUser.id}
                        ]
                    controller: 'EditEmployeeCtrl'
]
