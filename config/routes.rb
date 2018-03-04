Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # I like have a path prefix for short codes because it leaves open the
  # possibility for new endpoints for this app.
  resources :short_codes, path: 's', param: :code, only: [:show, :create]

  get "/stats/:short_code_id", to: "stats#index", as: "stats"

  root to: "welcome#index"
end
