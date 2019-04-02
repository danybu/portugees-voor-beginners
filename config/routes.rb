Rails.application.routes.draw do
  get 'words/index'
  get 'words/lookup'
  get 'lookup', to: 'words#lookup'
  devise_for :users
  root to: 'words#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
