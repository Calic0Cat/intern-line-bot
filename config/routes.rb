Rails.application.routes.draw do
  root 'welcome#index'

  # for LINE webhook
  post '/callback' => 'webhook#callback'
  post '/create' => 'coupons#create'
  get '/index' => 'coupons#index'
end
