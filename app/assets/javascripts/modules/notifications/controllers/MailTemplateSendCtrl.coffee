app = angular.module 'thms.controllers'

class MailTemplateSendCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$timeout', 'data', '$http', '$stateParams', '$humane', '$state'

    initialize: ->
#        @$scope.template = @template
        @$scope.loading = false
        @$scope.sendButtonText = 'Send Notification'
        @$scope.data =
            mail_template_id: @$stateParams.id

        @$scope.allCompaniesSelected = false
        @$scope.selectedCompanies = []
        @$scope.recipients = @data.data.recipients
        @$scope.events = @data.data.events




    toggleAllCompanies: ->
        angular.forEach @$scope.recipients, (r) => r.selected = @$scope.allCompaniesSelected
        @$scope.companySelectionChanged()

    selectCompaniesWithoutLease: ->
        angular.forEach @$scope.recipients, (r) -> r.selected = !r.has_facility
        @$scope.companySelectionChanged()

    selectCompaniesWithLease: ->
        angular.forEach @$scope.recipients, (r) -> r.selected = r.has_facility
        @$scope.companySelectionChanged()

    companySelectionChanged: ->
        @$scope.selectedCompanies = _.select @$scope.recipients, (r) => r.selected

    eventSelectionChanged: ->
        @$scope.selectedEvent = _.find @$scope.events, (event) =>
            @$scope.selectedEventDate = _.find event.event_dates, (date) =>
                date.id is @$scope.data.event_date_id


    sendButtonDisabled: ->
        return true if @$scope.loading
        @$scope.sendForm.$invalid || @$scope.selectedCompanies.length is 0

    sendNotify: (isTestNotification) ->

        if @$scope.selectedCompanies.length is 0 and isTestNotification == false
            @$humane.errorShort 'No Recipients Selected'
            return

        @$scope.loading = true
        @$scope.sendButtonText = 'Sending Notifications - Please Wait'
        @$scope.data.recipient_company_ids = new Array

        angular.forEach @$scope.recipients, (r) =>
            @$scope.data.recipient_company_ids.push r.id if r.selected


        data = angular.copy(@$scope.data)
        data.is_test_notification = isTestNotification

        @$http.post('/api/v2/notifications', data)
        .then (results) =>
            @$humane.stickySuccess 'Notifications Sent'
            @$state.go '^.index'
        .catch (error) =>
            console.log error
