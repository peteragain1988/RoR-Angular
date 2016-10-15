app = angular.module 'thms.services'

app.factory 'Roles', [ 'Auth', (Auth) ->
    allRoles = [
        {name: 'Standard User', value: 'standardUser?'},
        {name: 'Venue Admin', value: 'venueAdmin?'},
        {name: 'Client Admin', value: 'clientAdmin?'},
        {name: 'Super Admin', value: 'superAdmin?'}
    ]

    standardUserRoles = [
        allRoles[0]
    ]

    venueAdminRoles = [
        allRoles[0],
        allRoles[1]
    ]

    clientAdminRoles = [
        allRoles[0]
        allRoles[2]
    ]

    class Roles
        get: () ->
            permissions = Auth.currentUser.permissions
            return allRoles if permissions['super_admin?']
            return venueAdminRoles if permissions['venue_admin?']
            return clientAdminRoles if permissions['client_admin?']
            return standardUserRoles

    new Roles
]