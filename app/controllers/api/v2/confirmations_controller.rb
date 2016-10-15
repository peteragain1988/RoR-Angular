class Api::V2::ConfirmationsController < Api::V2::ApplicationController
  load_and_authorize_resource only: :show, class: 'ConfirmedInventoryOption'

  def index
    #TODO this is all shit.
    if params[:inventory_id]
      #TODO expand this to get more than just one confirmation, i.e: when we have a confirmation history
      #TODO anything less than status 'closed'
      @confirmation = ConfirmedInventoryOption.where(inventory_id: params[:inventory_id]).first
      render json: @confirmation
    elsif current_user.company.company_type == 'venue'
      @confirmations = ConfirmedInventoryOption.includes(:company, :facility, :event_date, :event).joins(:inventory)
        .where(inventory: {company_id: current_user.company.id}).references(:event_date).merge(EventDate.not_finished)

      render json: @confirmations
   else
     head :not_implemented
   end

  end

  def show
    render json: @confirmation
  end

  def update
    @confirmation = ConfirmedInventoryOption.find(params[:id])

    if @confirmation.update_attributes confirmation_params
      render json: @confirmation
    else
      render json: @confirmation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if ConfirmedInventoryOption.destroy(params[:id])
      head :no_content
    end
  end

  private
  def confirmation_params
    params.permit(
        guests: [:name],
        data: [
            :hardTicketsSent, :parkingAllocated,
            :parkingSpacesAllocated, :parkingAllocationDate,
            :parkingTicketsSent, :oysterSpecial
        ]
    )
  end
end