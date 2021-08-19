Rails.application.routes.draw do
  root 'welcome#index'

  # for LINE webhook
  post '/callback' => 'webhook#callback'
  get '/create' => 'coupons#create'
end
