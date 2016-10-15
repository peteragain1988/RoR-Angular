app = angular.module 'thms.modules.venue'

class ConfirmUserCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$state', '$log', '$stateParams', 'Confirm', '$humane'

    confirmEmployee: (password) ->
        @Confirm.send password, @$stateParams.token
        .then (message) =>
            @$humane.successShort message
            @$state.go 'guest.login'
