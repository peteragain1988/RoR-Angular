# Slowly going to become the bootstrap for the application
app = angular.module 'thms'

app.run [
  '$rootScope', '$localForage', 'Auth', '$state', '$timeout',  ($rootScope, $localForage, Auth, $state, $timeout) ->

    $rootScope.Auth = Auth

    $rootScope.$on 'event:redirect-home', ->
      $timeout ->
        $state.transitionTo 'redraw'
      , 100



    $rootScope.$on 'Auth::loggedIn', ->
      $state.transitionTo 'authenticated.main.home'

    $rootScope.$on 'Auth::loggedOut', ->
      $state.go 'guest.login'

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      event.preventDefault()

      continueRoute = ->
        $state.go toState.name, toParams, notify: false
        .then -> $rootScope.$broadcast('$stateChangeSuccess', toState, toParams, fromState, fromParams);

      checkLoggedIn = ->
        Auth.checkLoggedIn()
        .then -> continueRoute()
        .catch ->
          $state.go('guest.login',{},  notify: false)
          .then -> $rootScope.$broadcast('$stateChangeSuccess', toState, toParams, fromState, fromParams);

      if Auth.initialized
        if toState.data.requireLogin
          if Auth.currentUser then continueRoute() else checkLoggedIn()
        else
          $state.go('authenticated.main.home') if Auth.currentUser
          continueRoute() unless Auth.currentUser

      else
        Auth.populateLocalData()
        .finally ->
          if toState.data.requireLogin
            checkLoggedIn()
          else if toState.name is 'guest.login' && Auth.currentUser
            $state.go 'authenticated.main.home'
          else
            continueRoute()

]