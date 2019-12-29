class SignupController < ApplicationController
  skip_before_action :authenticate_request

  def create
    existing_user = User.find_by_email(user_params[:email])
    if existing_user.present?
      user_exists
    else
      user = User.new(user_params)
      if user.save
        token =  JsonWebToken.encode(user_id: user.id)
        render json: { current_user: user, jwt: token, message: 'User signed up successfully' }, status: :ok
      else
        render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_exists
    render json: { error: "User already exists" }, status: :user_exists
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
