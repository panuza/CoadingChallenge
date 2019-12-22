module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_access_request!

      # GET /answers
      def index
        @user = current_user

        render json: @user
      end
    end
  end
end
