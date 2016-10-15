app = angular.module 'thms.modules.venue'

#= services
#= controllers
app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider

        .state 'authenticated.main.clients',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.clients.view',
            url: '/clients/view'
            resolve:
                data: [
                    'Company', (Company) ->
                        console.log Company
                ]
            views:
                'content@authenticated':
                    templateUrl: 'clients/view.html'

        .state 'authenticated.main.clients.add',
            url: '/clients/new'
            views:
                'content@authenticated':
                    templateUrl: 'clients/new.html'
                    controller: 'NewClientCtrl'

        .state 'authenticated.main.clients.add.name',
            url: '/name'
            views:
                'steps':
                    templateUrl: 'clients/_new_name.html'

        .state 'authenticated.main.clients.add.address',
            url: '/address'
            views:
                'steps':
                    templateUrl: 'clients/_new_address.html'

        .state 'authenticated.main.clients.add.config',
            url: '/config'
            views:
                'steps':
                    templateUrl: 'clients/_new_config.html'

        .state 'authenticated.main.clients.add.admin',
            url: '/administrator'
            views:
                'steps':
                    templateUrl: 'clients/_new_admin.html'

        .state 'authenticated.main.clients.add.finance',
            url: '/finance'
            views:
                'steps':
                    templateUrl: 'clients/_new_financial_config.html'

]