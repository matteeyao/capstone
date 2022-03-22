Rails.application.routes.draw do
  resources :transactions
  get 'welcome/index'
  root :to => 'transactions#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
