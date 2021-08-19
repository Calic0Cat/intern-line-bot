Rails.application.routes.draw do
  resources :users

  root 'welcome#index'

  # for LINE webhook
  post '/callback' => 'webhook#callback'
end
