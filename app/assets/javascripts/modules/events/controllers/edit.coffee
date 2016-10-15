app = angular.module 'thms.modules.venue'

class EventEditCtrl extends BaseCtrl
    @register app

    @inject '$scope', 'event', '$state', '$humane', '$upload', '$timeout', '$window'

    # initialize the controller
    initialize: ->
        @$scope.event = angular.copy(@event)
        @$scope.buttonText = 'Save Changes'
        @$scope.loading = false

    save: (event, files) ->
        @$scope.buttonText = 'Saving...'
        @$scope.loading = true
        event.save(event.data, files)
        .then (result) =>
            @$humane.stickySuccess 'Event Saved'
            @$scope.$close(result)
        .catch (error) =>
            @$humane.stickyError 'Error Saving Event'
            @$scope.loading = false
            @$scope.buttonText = 'Save Changes'

    onFileSelect: (files, field) ->
        _.each files, (file) =>
            reader = new FileReader()
            # Once file reader has converted binary to base64 fire
            reader.onload = (event) =>
                @$timeout =>
                    @$scope.event.data[field] = event.target.result
                    @$scope.event.data['delete_' + field] = undefined
                , 0

            reader.readAsDataURL file

    removeAttachment: (field) ->
        @$scope.event.data['delete_' + field] = true
        @$scope.event.data[field] = ''

    getImage: (src) ->
        if src is ''
            '//:0'
        else
            src

    openUrl: (url) ->
        @$window.open url, '_blank'



