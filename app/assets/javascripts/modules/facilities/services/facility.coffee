app = angular.module 'thms.services'

app.factory 'Facility', [
    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
        class Facility extends RailsResource
            @configure
                url: '/api/v2/facilities',
                name: 'facility', pluralName: 'facilities'
                serializer: railsSerializer ->
                    @nestedAttribute 'facility_lease'
                    @resource 'facility_lease', 'FacilityLease'
]