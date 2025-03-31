Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :quotes, only: [ :index, :show ]
      get "/random", to: "quotes#random"
      get "/authors/:author", to: "quotes#by_author"
      get "/works/:work", to: "quotes#by_work"
      get "/eras/:era", to: "quotes#by_era"
      get "/tags/:tag", to: "quotes#by_tag"

      resources :tags, only: [ :index ]
    end
  end
end
