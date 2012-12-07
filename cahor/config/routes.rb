Cahor::Application.routes.draw do

  resources :sales, :only => [:create] 

  resources :orders, :only => [:new, :create] 
  get '/express' => 'orders#express', as: :express
  
  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  match "/api" => "clicks#create"
  
  devise_for :users

  root :to => "home#index"
end
