# frozen_string_literal: true

Rails.application.routes.draw do
  get 'profiles/home'
  get 'profiles/edit'
  get 'profiles/update'
  get 'help/index'
  root to: 'players#index'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end
  #   root 'login#index'
  resources :players
  resources :permissions
  resources :permission_users
  resources :images
  resources :events

  # get 'login/index'
  # get 'users/main'
  # get 'users/notes'
  get 'profiles/home'
  get 'profiles/edit'
  post 'profiles', to: 'profiles#update', as: :update_profile

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
