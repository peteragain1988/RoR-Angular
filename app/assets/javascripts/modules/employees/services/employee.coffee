app = angular.module 'thms.services'


app.factory 'Profile', [
    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
        class Profile extends RailsResource
            @configure
                url: '',
                name: 'profile', pluralName: 'profiles'
]

app.factory 'Employee', [
  'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
    url = '/api/v2/companies/{{companyId}}/employees/{{id}}'
    class Employee extends RailsResource
      @configure
        url: url,
        name: 'employee', pluralName: 'employees'
        serializer: railsSerializer ->
          @nestedAttribute 'profile_attributes'
#          @resource 'profile', 'Profile'
]