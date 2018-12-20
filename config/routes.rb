Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  get '/get_price_rule', to: 'api#get_price_rule'
  post '/multipass', to: 'api#multipass'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
