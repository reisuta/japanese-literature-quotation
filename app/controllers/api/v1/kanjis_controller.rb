module Api
  module V1
    class KanjisController < ApplicationController
      def index
        @kanjis = Kanji.all

        # Filter by grade if specified
        @kanjis = @kanjis.where(grade: params[:grade]) if params[:grade].present?

        # Filter by difficulty if specified
        @kanjis = @kanjis.where(stroke_count: params[:stroke_count]) if params[:stroke_count].present?

        # For typing practice
        if params[:purpose] == "typing"
          @kanjis = @kanjis.limit(params[:limit] || 10)
          render "kanjis/typing"
        else
          render json: @kanjis, status: :ok
        end
      end

      def show
        kanji = Kanji.find(params[:id])
        render json: kanji, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "漢字が見つかりません" }, status: :not_found
      end

      def random
        kanji = Kanji.order("RAND()").first
        if kanji
          render json: kanji, status: :ok
        else
          render json: { error: "漢字が見つかりません" }, status: :not_found
        end
      end

      def by_grade
        kanjis = Kanji.where(grade: params[:grade])
        render json: kanjis, status: :ok
      end

      def by_tag
        tag = Tag.find(params[:id])
        render json: tag.kanjis, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "タグが見つかりません" }, status: :not_found
      end
    end
  end
end
