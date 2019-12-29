class SignupController < ApplicationController
  def create
    existing_user = User.find_by_email(params[:email])
    if existing_user.present?
      user_exists
    else
      user = User.new(user_params)
      if user.save
        render json: { csrf: tokens[:csrf] }
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
