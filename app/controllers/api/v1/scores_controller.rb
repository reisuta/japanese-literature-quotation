module Api
  module V1
    class ScoresController < ApplicationController
      def index
        @scores = Score.recent
        
        # Filter by score type if specified
        @scores = @scores.by_score_type(params[:score_type]) if params[:score_type].present?
        
        # Filter by user if specified
        @scores = @scores.by_user(params[:user_name]) if params[:user_name].present?
        
        # Limit results
        @scores = @scores.limit(params[:limit] || 50)
        
        render json: @scores, status: :ok
      end

      def show
        score = Score.find(params[:id])
        render json: score, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "スコアが見つかりません" }, status: :not_found
      end

      def create
        score = Score.new(score_params)
        
        if score.save
          render json: score, status: :created
        else
          render json: { errors: score.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def leaderboard
        @scores = Score.by_score_type(params[:score_type] || 'quotes')
                      .top_scores(params[:limit] || 10)
        render json: @scores, status: :ok
      end

      def user_stats
        user_scores = Score.by_user(params[:user_name])
        
        stats = {
          total_games: user_scores.count,
          average_wpm: user_scores.average(:wpm)&.round(2),
          average_accuracy: user_scores.average(:accuracy)&.round(2),
          best_wpm: user_scores.maximum(:wpm),
          best_accuracy: user_scores.maximum(:accuracy),
          recent_scores: user_scores.recent.limit(5)
        }
        
        render json: stats, status: :ok
      end

      private

      def score_params
        params.require(:score).permit(:user_name, :score_type, :wpm, :accuracy, :time_taken, :completed_at)
      end
    end
  end
end