app = angular.module 'thms.modules.venue'

app.config [
  '$stateProvider', ($stateProvider) ->
    $stateProvider
    .state 'authenticated.main.tickets',
      abstract: true
      template: '<ui-view></ui-view>'
      
    .state 'authenticated.main.tickets.index',
      url: '/tickets'
      resolve: tickets: [
        '$http', ($http) -> $http.get '/api/v2/tickets'
      ]
      views:
        'content@authenticated':
          templateProvider: [
            'Auth'
            '$templateCache'
            (Auth, $templateCache) ->
              if Auth.currentUser.permissions['client_admin?']
                return $templateCache.get('tickets/index.html')
              if Auth.currentUser.permissions['venue_admin?']
                return $templateCache.get('tickets/venue_index.html')
              return
          ]
          controller: 'TicketsIndexCtrl'
        'header@authenticated': 
        	template: '<h1>Tickets</h1>'
    
    .state 'anz_authenticated.main.tickets',
      abstract: true
      template: '<ui-view></ui-view>'
    
    .state 'anz_authenticated.main.tickets.anz',
      url: '/tickets/anz/:auth_token'
      resolve: tickets: [
        'Tickets', '$stateParams', (Tickets, $stateParams) ->
          Tickets.anz_tickets($stateParams.auth_token)
      ]
      views:
        'content@anz_authenticated':
          templateUrl: 'tickets/anz_index.html',
          controller: 'TicketsIndexCtrl'
        'header@anz_authenticated':
          template: '<h1>Tickets</h1>'

    .state 'anz_authenticated.main.tickets.facility_view',
      url: '/tickets/anz/facility/:facility_name'
      resolve: tickets: [
        'Tickets', '$stateParams', (Tickets, $stateParams) ->
          Tickets.view_facility($stateParams.facility_name)
      ]
      views:
        'content@anz_authenticated':
          templateProvider: [
            'Auth'
            '$templateCache'
            (Auth, $templateCache) ->
              if Auth.currentUser.permissions['client_admin?']
                return $templateCache.get('tickets/anz_index.html')
              if Auth.currentUser.permissions['venue_admin?']
                return $templateCache.get('tickets/anz_index.html')
              return
          ]
          controller: 'TicketsIndexCtrl'
        'header@anz_authenticated':
          template: '<h1>Tickets</h1>'
]

