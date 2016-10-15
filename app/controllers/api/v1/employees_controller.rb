class Api::V1::EmployeesController < Api::V1::ApplicationController

  def index
    render json: current_user.company.employees.includes(:profile)
  end

  def create
    @employee = Employee.new employee_params.merge(permissions: attach_permissions)

    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end

  end

  private

  def employee_params
    params.permit(:company_id, :email, :permissions, :password,
                  profile_attributes: [:first_name, :last_name, :sex])
  end

  def attach_permissions
    permissions = params[:permissions]
    permissions[:can_login?] = true unless params[:permissions].eql?('login_disabled')
    permissions
  end
end
