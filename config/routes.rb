Rails.application.routes.draw do
  devise_for :users

  resources :trips

  root 'trips#index'
end
