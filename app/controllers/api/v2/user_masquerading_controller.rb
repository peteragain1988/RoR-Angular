class Api::V2::UserMasqueradingController < Api::V2::ApplicationController

  # User Masquerading
  # We are masquerading when we present a different header in the request
  # EH-Masquerading-As <user-id>
  # Still passing along the Authentcation Token


  def available_users
    authorize! :masquerade, Employee

    if current_user.super_admin?
      @employees = Employee.where.not(id: current_user.id).all
    elsif current_user.client_admin?
      @employees = current_user.company.employees.includes(:profile, :company).where.not(id: current_user.id)
    elsif current_user.venue_admin?
      @employees = Employee.includes(:profile, :company).where(company_id: current_user.company.client_ids).where.not(id: current_user.id)
    else
      @employees = []
    end

    # render json: @employees, each_serializer: EmployeeMasqueradingSerializer
    render
  end

  def current
    render json: current_user
  end

end
