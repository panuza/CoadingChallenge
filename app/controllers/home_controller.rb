class HomeController < ApplicationController
  def index
    @challenges = Challenge.all
    render json: @challenges
  end
end
