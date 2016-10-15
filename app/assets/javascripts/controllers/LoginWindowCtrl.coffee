app = angular.module('thms.controllers')

app.controller 'LoginWindowCtrl', [
    '$scope', 'Auth', '$state', ($scope, Auth, $state) ->

        setDefaultState = ->
            $scope.loginBtnText = "Login"
            $scope.showErrors = false
            $scope.mfaToken = false

        $scope.$root.$on 'event:auth-login-invalid', (event, data) ->



        $scope.doLogin =  ->
            $scope.loading = true

            Auth.login($scope.details)
            .then (result) =>
            	if(Auth.currentUser.email == "anz@venue.test")
            	  $state.go 'anz_authenticated.main.tickets.anz'
            	else
                  $state.go 'authenticated.main.home'
            .catch (error) =>
                $scope.invalidLogin = true
                $scope.errorMessage = 'Invalid email or password'
                setDefaultState()
                $scope.details.password = ''
                NProgress.done()
            .finally () =>
                $scope.loading = false

        setDefaultState()
]