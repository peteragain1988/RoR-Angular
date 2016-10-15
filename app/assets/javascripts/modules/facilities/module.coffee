app = angular.module 'thms.modules.venue'

app.config [
    '$stateProvider', ($stateProvider) ->
        $stateProvider

        .state 'authenticated.main.facility',
            abstract: true
            template: '<ui-view></ui-view>'

        .state 'authenticated.main.facility.index',
            url: '/facilities'
            resolve:
                facilities: [
                    'Facility', (Facility) ->
                        Facility.query()
                ]
            views:
                'content@authenticated':
                    templateUrl: 'facilities/main.html'
                    controller: 'FacilitiesIndexCtrl'
                'header@authenticated':
                    template: '<h1>Facility Management</h1>'

        .state 'authenticated.main.facility.view',
            url: '/facilities/:facility_id'
            resolve:
                facility: [
                    'Facility', '$stateParams', (Facility, $stateParams) ->
                        Facility.get($stateParams.facility_id)
                ]
#                leases: [
#                    'Lease', '$stateParams', (Lease, $stateParams) ->
#                        Lease.query(facility_id: $stateParams.facility_id)
#                ]
            views:
                'content@authenticated':
                    templateUrl: 'facilities/view.html',
                    controller: 'FacilityShowCtrl'
                'header@authenticated':
                    template: '<h1>Facility Management</h1>'
]