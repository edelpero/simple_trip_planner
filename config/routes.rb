Rails.application.routes.draw do
  devise_for :users

  resources :trips do
    collection do
      get :next_month
    end
  end

  root 'trips#index'
end
