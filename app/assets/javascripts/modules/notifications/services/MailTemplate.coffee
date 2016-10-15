app = angular.module 'thms.services'

app.factory 'MailTemplate', [
    'RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
        class MailTemplate extends RailsResource
            @configure
                url: '/api/v2/mail_templates',
                name: 'mail_template', pluralName: 'mail_templates'
#                serializer: railsSerializer ->
#                    @nestedAttribute 'facility_lease'
#                    @resource 'facility_lease', 'FacilityLease'
]