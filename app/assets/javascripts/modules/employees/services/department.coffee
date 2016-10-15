app = angular.module 'thms.services'

app.factory 'Department', [
    'RailsResource', (RailsResource) ->
        url = '/api/v2/companies/{{companyId}}/departments'
        class Department extends RailsResource
            @configure
                url: url,
                name: 'department', pluralName: 'departments'
]