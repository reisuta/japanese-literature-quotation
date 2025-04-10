Rails.application.routes.draw do
  get "jukugos/index"
  get "jukugos/show"
  get "jukugos/new"
  get "jukugos/create"
  get "jukugos/edit"
  get "jukugos/update"
  get "jukugos/destroy"
  get "kanjis/index"
  get "kanjis/show"
  get "kanjis/new"
  get "kanjis/create"
  get "kanjis/edit"
  get "kanjis/update"
  get "kanjis/destroy"
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
