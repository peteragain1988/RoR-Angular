app = angular.module 'thms.modules.venue'

class CompanyShowCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'company', '$modal', '$humane', '$timeout', 'leases', 'CompanyFacilityLease', '$stateParams'

    # initialize the controller
    initialize: ->
        @$scope.company = @company
        @$scope.leases = @leases

    editCompany: ->
        company = @$scope.company
        @modal = @$modal.open
            templateUrl: 'companies/edit.html'
            windowClass: 'effect-8'
#            backdrop: 'static'
            resolve:
                company: [
                    'Companies', '$stateParams', (Companies, $stateParams) ->
                        Companies.view($stateParams.company_id)
                ],
                employees: [
                    'Employee', (Employee) ->
                        Employee.get {'companyId': company.data.id}
                ]
            controller: 'CompanyEditCtrl'

        # Modal Closed Handler
        @modal.result
        .then (result) =>
            @$scope.company.data = result.data
        .catch (error) ->
            console.log error

    editLease: (lease) ->
        @modal = @$modal.open
            templateUrl: 'facilities/edit_lease.html'
            windowClass: 'effect-8'
            resolve:
                facilities: [
                    'Facility', (Facility) ->
                        Facility.query()
                ],
                companies:
                    # Injecting undefined as same controller is used in more than one place
                    # and we only need to choose facilities here, as we already have a company
                    () -> undefined
                lease: [
                    'CompanyFacilityLease', '$stateParams', (CompanyFacilityLease, $stateParams) ->
                        CompanyFacilityLease.get companyId: $stateParams.company_id, id: lease.id
                ]

            controller: 'EditFacilityLeaseCtrl'
        @modal.result
        .then (result) =>
            @CompanyFacilityLease.get(companyId: @$stateParams.company_id)
            .then (results) =>
                @$scope.leases = results

    newLease: ->
        @modal = @$modal.open
            templateUrl: 'facilities/new_lease.html'
            windowClass: 'effect-8'
            resolve:
                facilities: [
                    'Facility', (Facility) ->
                        Facility.query()
                ],
                companies:
                # Injecting undefined as same controller is used in more than one place
                # and we only need to choose facilities here, as we already have a company
                    () -> undefined
                lease: [
                    'CompanyFacilityLease', '$stateParams', (CompanyFacilityLease, $stateParams) =>
                        new CompanyFacilityLease company_id: $stateParams.company_id, is_enabled: true
                ]

            controller: 'EditFacilityLeaseCtrl'
        # Modal Closed Handler
        @modal.result
        .then (result) =>
            @CompanyFacilityLease.get(companyId: @$stateParams.company_id)
            .then (results) =>
                @$scope.leases = results
