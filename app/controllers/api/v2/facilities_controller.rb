class Api::V2::FacilitiesController < Api::V2::ApplicationController
  load_and_authorize_resource

  def index
    @facilities = @facilities.includes(current_active_lease:[:company] )
    render
  end

  def show
    render
  end

  def update
    if @facility.update_attributes facility_params
      render json: @facility, status: :ok
    else
      render json: @facility.errors, status: :unprocessable_entity
    end

  end

  def destroy
  end

  def create
    if @facility.save
      render :show, status: :created
    else
      render json: @facility.errors, status: :unprocessable_entity
    end
  end

  private
  def facility_params
    params.require(:facility).permit(
        :name, :capacity, :facility_type,
        facility_leases_attributes: [
            :id, :company_id, :start, :finish, :is_enabled
        ]
    )
  end
end
