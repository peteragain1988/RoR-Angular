angular.module 'thms.controllers', []
angular.module 'thms.filters', []
angular.module 'thms.services', []
angular.module 'thms.directives', []

app = angular.module 'thms', [
    'ui.router', 'thms.controllers', 'thms.services',
    'thms.directives', 'thms.filters', 'ui.bootstrap',
    'restangular','ngSanitize', 'templates', 'angularMoment',
    'thms.modules.venue', 'LocalStorageModule'
]

app.config [
    '$stateProvider', '$urlRouterProvider', '$locationProvider',
    ($stateProvider, $urlRouterProvider, $locationProvider) ->
        $urlRouterProvider.otherwise '/'

#        $locationProvider.html5Mode true

        $stateProvider
        .state 'guest',
            abstract: true
            templateUrl: 'layouts/guest.html'
            resolve:
                currentUser: [
                    'Auth', '$state', (Auth, $state) ->
                        Auth.checkLoggedIn()
                        .then ->
                            $state.go 'authenticated.main.home'
                ]

        .state 'guest.login',
            url: '/',
            views:
                'content@guest':
                    templateUrl: 'login.html',
                    controller: 'LoginWindowCtrl'

        .state 'authenticated',
            abstract: true
            templateUrl: 'layouts/authenticated.html'

        .state 'anz_authenticated',
          abstract: true
          templateUrl: 'layouts/anz_authenticated.html'
]