app = angular.module 'thms.services'

app.factory 'FacilityLease', [
    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
        class FacilityLease extends RailsResource
            @configure url: "/api/v2/facilities/{{facilityId}}/facility_leases/{{id}}", name: 'facility_lease', pluralName: 'facility_leases'
]

app.factory 'CompanyFacilityLease', [
    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
        class CompanyFacilityLease extends RailsResource
            @configure url: "/api/v2/companies/{{companyId}}/facility_leases/{{id}}", name: 'facility_lease', pluralName: 'facility_leases'
]

#
#app.factory 'Lease', ['$http', '$q', ($http, $q) ->
#    BASE_URL = '/api/v2/leases/'
#
#    class Lease
#        constructor: (@data, @edited = false) ->
#            @data = {} if not @data
#            @url = if @data.id then BASE_URL + @data.id  else BASE_URL
#
#        save: (data = @data) ->
#            defferred = $q.defer()
#
#            method = if @data.id then 'PUT' else 'POST'
#
#            $http
#                method: method
#                url: @url
#                data: data
#            .then (result) =>
#                @data = result.data
#                defferred.resolve @
#            .catch (error) =>
#                defferred.reject error
#
#            defferred.promise
#
#]

