# frozen_string_literal: true

Rails.application.routes.draw do
<<<<<<< HEAD
  resources :events
    root to: 'players#index'
    devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
    devise_scope :admin do
        get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
        get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
    end
    #   root 'login#index'
    resources :players
=======
  root to: 'players#index'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end
  #   root 'login#index'
  resources :players
>>>>>>> 41eab3a2eb57f1fb59545019de2fe27c8d7b5abc

  get 'login/index'
  get 'users/main'
  get 'users/notes'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
