Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'books#index'

  devise_for :users

  resources :books do
    post :rent
    post :deliver_back
  end
end
