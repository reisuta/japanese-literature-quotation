module Api
  module V1
    class QuotesController < ApplicationController
      def index
        @quotes = Quote.all

        if params[:purpose] == "typing"
          render "quotes/typing"
        else
          render json: @quotes, status: :ok
        end
      end

      def show
        quote = Quote.find(params[:id])
        render json: quote, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "引用が見つかりません" }, status: :not_found
      end

      def random
        quote = Quote.order("RAND()").first
        if quote
          render json: quote, status: :ok
        else
          render json: { error: "引用が見つかりません" }, status: :not_found
        end
      end

      def by_author
        quotes = Quote.where("author LIKE ?", "%#{params[:author]}%")
        render json: quotes, status: :ok
      end

      def by_work
        quotes = Quote.where("work LIKE ?", "%#{params[:work]}%")
        render json: quotes, status: :ok
      end

      def by_era
        quotes = Quote.where("era LIKE ?", "%#{params[:era]}%")
        render json: quotes, status: :ok
      end

      def by_tag
        tag = Tag.find_by(name: params[:tag])
        if tag
          render json: tag.quotes, status: :ok
        else
          render json: { error: "タグが見つかりません" }, status: :not_found
        end
      end
    end
  end
end
