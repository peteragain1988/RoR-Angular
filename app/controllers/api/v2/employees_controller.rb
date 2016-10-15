class Api::V2::EmployeesController < Api::V2::ApplicationController
before_action :fetch_employee, only: [:show, :update]
skip_before_filter :authenticate_user, only: [:password_reset]
  def index
    @employees = Company.find_by_id(params[:company_id]).employees.includes(:profile)
    render
  end

  def show
    render
  end

  def create
    @employee = Employee.new employee_params.merge(permissions: permissions)
    app_path = generate_approval_path
    @employee.approval_path = ApprovalPath.new(path: app_path) unless app_path.all? { |p| p.nil? }
    @employee.password = 'eventhub'
    if @employee.save
      MailgunMailer.welcome_user_notification(@employee).deliver
      render template: 'api/v2/employees/show', status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update_attributes employee_params.merge(permissions: permissions,
                                                         approval_path_attributes: { id: @employee.approval_path_id,
                                                                                     path: generate_approval_path })
      render template: 'api/v2/employees/show', status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def password_reset
    if params[:token] && params[:password]
      @employee = Employee.for_password_token(params[:token])
      @employee.password = params[:password]

      if @employee.save
        render json: { message: 'Your account has been confirmed' }, status: :ok
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'Not all activation params were provided.' }, status: :unprocessable_entity
    end
  end

  def report_incorrect_data
    manager = Employee.find_by_id(current_user.company.manager_id)
    if params[:comment]
      MailgunMailer.report_incorrect_profile_data(manager, current_user, params[:comment])

      render json: { message: 'Issue is reported to company manager' }, status: :ok
    else
      render json: { message: 'Comment must be provided.' }, status: :unprocessable_entity
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:company_id, :email, :department_id, :state,
                                     :position, :cost_center, :bi_access,
                  profile_attributes: [:id, :first_name, :last_name, :sex, :klass])
  end

  def fetch_employee
    @employee = Employee.find_by(company_id: params[:company_id], id: params[:id])
    render json: { employee: { error: 'Employee not found.' } },
           status: :no_content unless @employee.present?
  end

  def permissions
    params[:employee][:permissions]
  end

  def generate_approval_path
    [
        params[:employee][:first_manager],
        params[:employee][:second_manager],
        params[:employee][:third_manager]
    ]

  end
end
