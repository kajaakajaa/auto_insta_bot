Rails.application.routes.draw do
  root "pages#index"
  devise_for :users
  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  resources :users, only: %i[destroy] do
    resources :pages, only: %i[index show]
  end
end
