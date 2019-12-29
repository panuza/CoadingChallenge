module Api
  module V1
    class ChallengesController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_challenge, only: [:show, :update, :destroy]

      # GET /challenges
      def index
        @challenges = Challenge.all

        render json: @challenges
      end

      def my_challenges
        @challenges = current_user.challenges.all

        render json: @challenges
      end

      # GET /challenges/1
      def show
        render json: @challenge
      end

      # POST /challenges
      def create
        @challenge = Challenge.new(challenge_params)
        @challenge.user_id = current_user.id
        if @challenge.save
          render json: @challenge, status: :created
        else
          render json: @challenge.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /challenges/1
      def update
        if @challenge.update(challenge_params)
          render json: @challenge
        else
          render json: @challenge.errors, status: :unprocessable_entity
        end
      end

      # DELETE /challenges/1
      def destroy
        @challenge.destroy
      end

      def top
        start_of_week = Time.current.beginning_of_week
        end_of_week = Time.current.end_of_week

        @top_challenges = Challenge.joins(:answers).where(answers: { updated_at: start_of_week..end_of_week }).group("challenges.id").order("count(answers.challenge_id) DESC").limit(10)
        render json: @top_challenges
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_challenge
          @challenge = Challenge.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def challenge_params
          params.require(:challenge).permit(:name, :description, :question, :category, :difficulty_level)
        end
    end
  end
end 