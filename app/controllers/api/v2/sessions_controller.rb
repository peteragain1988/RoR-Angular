class Api::V2::SessionsController < Api::V2::ApplicationController

  skip_filter :authenticate_user, only: :create

  def index
    @user = current_user
    render json: @user
  end

  def create
    if params[:email] && params[:password]
      @user = Employee.find_by_email params[:email]

      # Validate that the user has been found and that the password is valid
      if @user && @user.authenticate(params[:password]) && @user.can_login?

        # Set our token in the header for the program to extract and store
        response.headers['X-Set-Auth-Token'] = AuthenticationToken.issue_token({:user_id => @user.id})

        # Send our response
        return render json: @user, status: :created
      end
    end

    head :unauthorized
  end

  # def create
  #   @user = Employee.find_by(email: params[:email].downcase)
  #   if @user && @user.can_login? && @user.authenticate(params[:password])
  #
  #     if @user.otp_secret
  #       unless params[:totp] && @user.verify_totp(params[:totp])
  #         head :unauthorized
  #         return
  #       end
  #     end
  #
  #     token = SecureRandom.uuid
  #
  #     Rails.cache.write(token, @user, expires_in: 15.hours)
  #
  #     headers['X-Set-Auth-Token'] = token
  #     render json: @user, status: :created
  #   else
  #     head :unauthorized
  #   end
  # end

end