Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

  namespace :app_proxy do
    root action: 'index'
    # simple routes without a specified controller will go to AppProxyController
    
    # more complex routes will go to controllers in the AppProxy namespace
    # 	resources :reviews
    # GET /app_proxy/reviews will now be routed to
    # AppProxy::ReviewsController#index, for example
    post '/update', action: 'update'
    get '/join', action: 'join'
    post '/join', action: 'create'
    get '/account', to: 'account#index'
    get '/veterinarian/join', action: 'vet_join'
    post '/veterinarian/join', action: 'vet_create'
  end
  get '/get_price_rule', to: 'api#get_price_rule'
  post '/multipass', to: 'api#multipass'
  post '/customer_update', to: 'api#customer_update'
  post '/modulus_update', to: 'api#modulus_update'
  post '/modulus_getdetails', to: 'api#modulus_getdetails'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
