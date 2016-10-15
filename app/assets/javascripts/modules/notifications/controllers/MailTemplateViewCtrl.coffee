app = angular.module 'thms.controllers'

class MailTemplateViewCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'template'

    initialize: ->
        @$scope.template = @template

    saveTemplate: ->
        @$scope.template.save()
        .then (result) =>
            console.log 'saved'