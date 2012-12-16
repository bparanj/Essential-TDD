Cahor::Application.routes.draw do

  resources :payment_notifications, :only => [:create] 

  resources :orders, :only => [:new, :create] 
  get '/express' => 'orders#express', as: :express
  
  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  match "/asp" => "clicks#create"
  
  devise_for :users

  root :to => "home#index"
end
