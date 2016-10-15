app = angular.module 'thms.modules.venue'

class NewClientCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'Company', '$state', '$humane', 'Employee', 'Roles'

    initialize: ->
        @$scope.company = new @Company()
        @$state.go 'authenticated.main.clients.add.name'
        @$scope.roles = @Roles.get()

    updatePermissions: (model) ->
        model.permissions =
            'canLogin?': true
        model.permissions[model.permission] = true if model.permission

    save: (saveManager)->
        @$scope.manager = @$scope.company.data.manager
        @$scope.company.save()
        .then (result) =>
            if saveManager == true
                @$state.go 'authenticated.main.company.view', {company_id: result.data.id}
                @$humane.stickySuccess 'Company Created'
            else
                @$scope.createManager(result.data)
        .catch (error) =>
            console.warn error

    createManager: (company) ->
        @$scope.company.data.id = company.id
        @$scope.company.data.manager = @$scope.manager
        @$scope.updatePermissions(@$scope.company.data.manager)
        @$scope.company.data.manager.company_id = company.id
        companyManager = new @Employee(@$scope.company.data.manager)
        companyManager.company_id = company.id
        companyManager.save()
        .then (result) =>
            @$scope.company.data.manager_id = result.id
            @$scope.company = new @Company(@$scope.company.data)
            @$scope.save true