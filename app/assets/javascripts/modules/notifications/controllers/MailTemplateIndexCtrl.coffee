app = angular.module 'thms.controllers'

class MailTemplateIndexCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'templates', '$modal', '$log', '$http', '$window', 'MailTemplate', '$humane', '$timeout', '$state'

    initialize: ->
        @$scope.templates = @templates

        @$scope.$on '$destroy', =>
            @$scope.modal.close() if @$scope.modal


    viewTemplate: (id) ->
        console.log id
        @$scope.modal = @$modal.open
            resolve:
                template: [ 'MailTemplate', (MailTemplate) -> MailTemplate.get id ]
            templateUrl: 'notifications/templates/modal_view.html'
            controller: ['template', '$scope', (template, $scope) -> $scope.template = template]

    deleteTemplate: (template) ->
        killItWithFire = @$window.confirm "Are you sure you want to delete template #{template.name}?"

        if killItWithFire
            mt = new @MailTemplate(id: template.id)
            mt.delete()
            .then (result) =>
                @$humane.successShort 'Template Deleted'
                @$scope.templates = _.without @$scope.templates, template
            .catch (error) =>
                @$humane.errorShort 'Error deleting template'