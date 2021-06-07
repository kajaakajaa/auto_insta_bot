Rails.application.routes.draw do
  root "pages#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  devise_scope :user do
    get "/users/sign_out" => "users/sessions#destroy"
  end

  resources :users, only: %i[destroy]
  resources :pages, only: %i[index show] do
    get :top, on: :collection
    get :set, on: :member
    get :history, on: :member
  end
end
