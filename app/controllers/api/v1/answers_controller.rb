# frozen_string_literal: true

module Api
  module V1
    class AnswersController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_answer, only: %i[show update destroy]

      # GET /answers
      def index
        @answers = Answer.all

        render json: @answers
      end

      def challenge_answers
        @answers = Answer.where(challenge_id: params[:challenge_id])

        render json: @answers
      end

      def up_vote
        @answer = Answer.find(params[:id])
        @user = User.find(@answer.user_id)
        @answer.upvote_from @user

        unless (@answer.get_upvotes.size % 10).zero?
          @user.update(skill_level: @answer.get_upvotes.size)
        end

        render json: @answer
      end

      def down_vote
        @answer = Answer.find(params[:id])
        @user = User.find(@answer.user_id)

        if @user.skill_level >= 10
          @user.downvote_from @user
        end
        render json: @answer
      end

      # GET /answers/1
      def show
        render json: @answer
      end

      # POST /answers
      def create
        @answer = Answer.new(answer_params)
        given_answer = Answer.where(user_id: current_user.id, challenge_id: params[:answer][:challenge_id])
        if given_answer.present?
          answer_found
        else
          if @answer.save
            render json: @answer, status: :created
          else
            render json: @answer.errors, status: :unprocessable_entity
          end
        end
      end

      # PATCH/PUT /answers/1
      def update
        if @answer.update(answer_params)
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      # DELETE /answers/1
      def destroy
        @answer.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_answer
        @answer = Answer.find(params[:id])
      end

      def answer_found
        render json: { error: 'You have already answered to this challenge.' }, status: :answer_found
      end

      # Only allow a trusted parameter "white list" through.
      def answer_params
        params.require(:answer).permit(:answer, :user_id, :challenge_id)
      end
    end
  end
end
