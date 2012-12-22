Cahor::Application.routes.draw do

  resources :payment_notifications, :only => [:create] 

  resources :products
  resources :orders, :only => [:new, :create] 
  
  get '/express' => 'orders#express', as: :express
  get '/downloads/:confirmation_number' => 'downloads#show'
  
  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  match "/asp" => "clicks#create"
  
  devise_for :users

  root :to => "home#index"
end
