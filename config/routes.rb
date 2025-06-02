Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Quotes API
      resources :quotes, only: [ :index, :show ] do
        collection do
          get :random
        end
      end
      get "authors/:author/quotes", to: "quotes#by_author"
      get "works/:work/quotes", to: "quotes#by_work"
      get "eras/:era/quotes", to: "quotes#by_era"

      # Kanjis API
      resources :kanjis, only: [ :index, :show ] do
        collection do
          get :random
        end
      end
      get "grades/:grade/kanjis", to: "kanjis#by_grade"

      # Jukugos API
      resources :jukugos, only: [ :index, :show ] do
        collection do
          get :random
        end
      end
      get "difficulty/:difficulty/jukugos", to: "jukugos#by_difficulty"

      # Scores API
      resources :scores, only: [ :index, :show, :create ]
      get "leaderboard/:score_type", to: "scores#leaderboard"
      get "users/:user_name/stats", to: "scores#user_stats"

      # Tags API (shared across all resources)
      resources :tags, only: [ :index ] do
        member do
          get "quotes", to: "quotes#by_tag"
          get "kanjis", to: "kanjis#by_tag"
          get "jukugos", to: "jukugos#by_tag"
        end
      end
    end
  end

  # Legacy routes (to be removed)
  resources :kanjis, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :jukugos, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
end
