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
  resources :pages, only: %i[index] do
    get :top, on: :collection
    get :set, on: :member
    get :history, on: :member
    get :change, on: :member
    get :user_policy, on: :collection
    get :privacy_policy, on: :collection
    get :asct, on: :collection
    get :line_contact, on: :collection
  end
end
