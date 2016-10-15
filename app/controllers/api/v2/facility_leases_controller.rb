class Api::V2::FacilityLeasesController < Api::V2::ApplicationController
  load_resource :company
  load_resource :facility
  load_and_authorize_resource through: [:company, :facility]

  def index
    # if params[:company_id]
    #   @leases = FacilityLease.where(company_id: params[:company_id]).includes(:facility)
    #   render json: @leases
    # elsif params[:facility_id]
    #   @leases = FacilityLease.where(facility_id: params[:facility_id]).includes(:company)
    #   render json: @leases
    # else
    #   head :not_found
    # end
    #
    render
  end

  def show
    render
  end

  def update
    if @facility_lease.update_attributes facility_lease_params
      render :show
    else
      render json: @facility_lease.errors, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def create
    if @facility_lease.save
      render :show, status: :created
    else
      render json: @facility_lease.errors, status: :unprocessable_entity
    end
  end

  private

  def facility_lease_params
    params.require(:facility_lease).permit(:facility_id, :company_id, :start, :finish, :is_enabled)
  end

end
