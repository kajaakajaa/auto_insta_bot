Rails.application.routes.draw do
  root "pages#index"
  devise_for :users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  resources :users, only: %i[destroy]
  resources :pages, only: %i[index show] do
    get :top, on: :collection
  end
end
