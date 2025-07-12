Rails.application.routes.draw do
  get "home/index"
  # Home dashboard
  root 'home#index'

  # Admin dashboard for elections and candidates
  namespace :admin do
    resources :elections, only: [:index, :new, :create, :show, :edit, :update, :destroy]
    resources :candidates, only: [:new, :create]
  end

  # User registration routes
  resources :users, only: [:new, :create] do
    member do
      get :verify
      post :submit_verification
      post :resend_verification
    end
  end

  # Election and voting routes
  resources :elections, only: [:show] do
    member do
      get :ballot
      post :submit_ballot
      get :ballot_success
      get :results
    end
  end

  # Delegation routes
  resources :delegations, only: [:new, :create, :index]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
