class HomeController < ApplicationController
  skip_before_action :authenticate_request, only: :index

  def index
    @challenges = Challenge.all
    render json: @challenges
  end
end
