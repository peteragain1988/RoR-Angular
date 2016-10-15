class Api::V2::DepartmentsController < Api::V2::ApplicationController
  before_action :fetch_departments, only: [:index]
  def index
    render json: @departments
  end

  private
  def fetch_departments
    @departments = Department.where(company_id: params[:company_id])
    render json: { department: { error: 'There are no departments in mentioned company.' } },
           status: :no_content unless @departments.present?
  end
end
