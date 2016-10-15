app = angular.module 'thms.controllers'

class MailTemplateNewCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'template', '$humane', '$state'

    initialize: ->
        @$scope.template = @template

    saveTemplate: ->
        @$scope.loading = true
        @$scope.template.save()
        .then (result) =>
            @$state.go '^.index'
            @$humane.successShort 'Mail Template Saved'
        .catch (error) =>
            @$scope.loading = false
            console.log error
            @$humane.errorShort 'Error Saving Mail Template'