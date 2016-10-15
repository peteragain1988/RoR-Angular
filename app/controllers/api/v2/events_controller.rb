class Api::V2::EventsController < Api::V2::ApplicationController
  load_and_authorize_resource only: [:index]
  def index

    if params[:status]
      @events = @events.where(status: params[:status])
    else
      @events = @events.not_closed
    end

    render json: @events
  end

  def show
    @event = Event.find(params[:id])

    if @event
      render json: @event
    else
      head :not_found
    end

  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes event_params
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end

  end

  def create
    @event = Event.new event_params
    #TODO Fix this
    @event.company = current_user.company
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
  end


  private

  def event_params
    params.permit(
        :name, :description, :event_type, :status,
        :tile, :agenda, :menu, :delete_tile, :delete_agenda,
        :delete_menu, :promoter
    )
  end
end
