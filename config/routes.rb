Rails.application.routes.draw do
  root 'users#main'

  get 'login/index'
  get 'users/main'
  get 'users/notes'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #default route
  get ':controller(/:action(/:id))'

  
end
