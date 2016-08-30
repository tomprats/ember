Rails.application.routes.draw do
  root "sessions#new"
  get "auth/facebook/callback", to: "sessions#create"
  get :logout, to: "sessions#destroy"

  resources :matches, only: [:index, :show]
  resources :matching, only: [:index, :show, :update]
  get :refresh, to: "matching#refresh"
  get "p/:id", to: "personalities#show", as: :personality

  get :assessment, to: "matching#assessment"
end
