class SigninController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token =  JsonWebToken.encode(user_id: user.id)
      render json: { current_user: user, jwt: token, success: "Welcome back, #{user.first_name}" }
    else
      render json: { failure: "Log in failed! Username or password invalid!" }
    end
  end

  def destroy
    session[:user_id] = nil
    render json: :ok
  end

  private

  def not_found
    render json: { error: "Cannot find email/password combination" }, status: :not_found
  end
end
