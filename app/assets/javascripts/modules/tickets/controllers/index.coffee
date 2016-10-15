  
app = angular.module 'thms.modules.venue'

class TicketsIndexCtrl extends BaseCtrl
    @register app

    @inject '$scope', '$state', '$modal', '$window', '$http', 'tickets'

    # initialize the controller
    initialize: ->
        @$scope.data = @tickets.data
        if !@$scope.data.events
          anz_page = document.getElementById('anz_page')
          anz_page.parentNode.removeChild(anz_page)
        else if !@$scope.data.token_flag && @$scope.data.anz_flag
          document.getElementById('anz_error').style.display = "none"
          document.getElementById('anz_email').innerHTML = @$scope.data.email

    viewTicket: (ticket) ->
      
    	if ticket.storage['storage_type'] == 'remote'
	      file = ticket.s3_file_name
	    else
	      file = ticket.storage['file_name']
	      
      modal = @$modal.open
        template: "<div class='panel'><iframe src='#{file}'></iframe></div>"
        windowClass: 'effect-0 xxlarge xxtall'

    downloadAllTickets: (event) ->
        @$window.open "/api/v2/my/inventory/#{event.inventory_id}/client/#{event.client_id}/tickets/zip", "_blank"
        index = this.$scope.data.events.indexOf(event)
        @$scope.data.events[index].download_status = true
        return
    downloadPdf: (ticketID) ->
        @$window.open "/api/v2/tickets/ticket/#{ticketID}/download", "_blank"