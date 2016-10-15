app = angular.module 'thms.modules.venue'

#= services
#= controllers


app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider
        .state 'authenticated.main.company',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.company.index',
            url: '/companies'
            resolve:
                data: [
                    'Companies', (Companies) ->
                        Companies.sync()
                ]
            views:
                'content@authenticated':
                    templateUrl: 'companies/index.html'
                    controller: 'CompanyIndexCtrl'
                'header@authenticated':
                    template: '<h1>Company Management</h1>'

        .state 'authenticated.main.company.add',
            views:
                'content@authenticated':
                    templateUrl: 'companies/add.html'
                    controller: [
                        '$scope', ($scope) ->
                            $scope.email = ''
                    ]

        .state 'authenticated.main.company.add.search',
            url: '/companies/add/search'
            views:
                form:
                    templateUrl: 'companies/searchByEmail.html'

        .state 'authenticated.main.company.view',
            url: '/companies/:company_id'
            resolve:
                company: [
                    'Companies', '$stateParams', (Companies, $stateParams) ->
                        Companies.view $stateParams.company_id
                ],
                leases: [
                    'CompanyFacilityLease', '$stateParams', (CompanyFacilityLease, $stateParams) ->
                        CompanyFacilityLease.get companyId: $stateParams.company_id
                ]
            views:
                'content@authenticated':
                    templateUrl: 'clients/view.html'
                    controller: 'CompanyShowCtrl'

        .state 'authenticated.main.company.add.showResult',
            url: '/companies/add/search/results'
            views:
                form:
                    templateUrl: 'companies/addSearchResults.html'
]