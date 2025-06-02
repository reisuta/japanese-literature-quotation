module Api
  module V1
    class JukugosController < ApplicationController
      def index
        @jukugos = Jukugo.all

        # Filter by difficulty if specified
        @jukugos = @jukugos.where(difficulty: params[:difficulty]) if params[:difficulty].present?

        # For typing practice
        if params[:purpose] == "typing"
          @jukugos = @jukugos.limit(params[:limit] || 10)
          render "jukugos/typing"
        else
          render json: @jukugos, status: :ok
        end
      end

      def show
        jukugo = Jukugo.find(params[:id])
        render json: jukugo, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "熟語が見つかりません" }, status: :not_found
      end

      def random
        jukugo = Jukugo.order("RAND()").first
        if jukugo
          render json: jukugo, status: :ok
        else
          render json: { error: "熟語が見つかりません" }, status: :not_found
        end
      end

      def by_difficulty
        jukugos = Jukugo.where(difficulty: params[:difficulty])
        render json: jukugos, status: :ok
      end

      def by_tag
        tag = Tag.find(params[:id])
        render json: tag.jukugos, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "タグが見つかりません" }, status: :not_found
      end
    end
  end
end
