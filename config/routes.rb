Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post :episodes_from_json, controller: :episode, action: :from_json
  post :episodes_from_url, controller: :episode, action: :from_url

  post :orchestrations, controller: :orchestration, action: :all
  get 'orchestrations/:id', controller: :orchestration, action: :by_id
  post 'orchestrations/:id/cancel', controller: :orchestration, action: :cancel_by_id
end
