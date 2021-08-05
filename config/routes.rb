Rails.application.routes.draw do
  root "users#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
  }
  devise_scope :user do
    get "/users/sign_out" => "users/sessions#destroy"
  end
  # users
  resources :users, only: %i[index destroy] do
    get :top, on: :collection
    get :set, on: :member
    get :history, on: :collection
    get :change, on: :member
    get :user_policy, on: :collection
    get :privacy_policy, on: :collection
    get :asct, on: :collection
    get :line_contact, on: :collection
    get :management, on: :collection
    get :activity, on: :member
    get :analytics, on: :collection
  end
  # instabots
    get "instabots" => "instabots#sign_in"
    post "instabots" => "instabots#create"
    post "instabots/auto" => "instabots#auto", as: :instabots_auto
    
    # hashtags
    post "hashtags" => "hashtags#hashtag", as: :hashtag
    delete "hashtags/delete/:id" => "hashtags#destroy", as: :hashtag_destroy
end
