Cahor::Application.routes.draw do

  resources :sales, :only => [:create] 

  resources :orders, :only => [:new, :create] 
  get '/express' => 'orders#express', as: :express
  

  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  
  devise_for :users

  root :to => "home#index"
end
