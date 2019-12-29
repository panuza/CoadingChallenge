class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      command = AuthenticateUser.call(params[:email], params[:password])
      render json: { current_user: user, jwt: command.result, success: "Welcome back, #{user.first_name}" }
    else
      render json: { failure: "Log in failed! Username or password invalid!" }
    end
  end

  # def destroy
  #   session.flush_by_access_payload
  #   render json: :ok
  # end

  private

  def not_found
    render json: { error: "Cannot find email/password combination" }, status: :not_found
  end
end