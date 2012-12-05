Cahor::Application.routes.draw do
  get "sales/create"

  resources :orders, :only => [:new, :create] 
  get '/express' => 'orders#express', as: :express
  
  get "affiliates/create"

  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  
  devise_for :users

  root :to => "home#index"
end
