app = angular.module 'thms.modules.venue'

class ClientShowCtrl extends BaseCtrl
  @register app

  @inject '$scope', 'company', '$state'

  # initialize the controller
  initialize: ->
    @$scope.data = @company