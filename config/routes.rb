Timecard::Application.routes.draw do
  resource :dashboard, only: :show
  devise_for :users, controllers:  { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }
  resources :users, only: [:show] do
    resources :workloads, only: [:index] do
      get '/:year/:month/:day', on: :collection, to: 'workloads#index', as: :daily
    end
    resources :authentications
  end

  resources :members, only: [:destroy]
  resources :data

  resources :comments, only: [:edit, :update, :destroy]
  resources :workloads, only: [:edit, :update, :destroy, :stop] do
    patch :stop, on: :member
  end

  resources :issues, only: [:index, :show, :edit, :update, :close, :reopen] do
    patch :close, on: :member
    patch :reopen, on: :member
    patch :postpone, on: :member
    patch :do_today, on: :member
    resources :comments, only: [:create]
    resource :workloads, only: [:start] do
      post :start, on: :member
    end
  end

  resources :projects do
    patch :archive, on: :member
    patch :active, on: :member
    patch :close, on: :member
    resources :issues, only: [:new, :create]
    resources :members, only: [:index, :create]
  end

  delete "users/disconnect/:provider", to: "users#disconnect", as: :disconnect_provider
  root :to => "home#index"
end
