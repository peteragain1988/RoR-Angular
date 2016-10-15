# class Api::V2::My::TicketsController < Api::V2::ApplicationController
#   load_and_authorize_resource
#   skip_load_and_authorize_resource only: :index
#
#   def index
#       @events = Event.includes(
#           dates: [
#               tickets: [:facility]
#           ]
#       ).merge(Ticket.accessible_by current_ability).merge(EventDate.not_finished).references(:tickets)
#
#     render 'api/v2/my/tickets/index'
#   end
# end
