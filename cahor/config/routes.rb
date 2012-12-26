Cahor::Application.routes.draw do

  resources :payment_notifications, :only => [:create] 

  resources :products do
    resources :landing_pages, :except => [:index, :show] 
  end
  
  resources :orders, :only => [:new, :create] 

  get '/landing_pages_home' => 'landing_pages#home'
  get '/express' => 'orders#express', as: :express
  get '/downloads/:confirmation_number' => 'downloads#show'
  
  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  match "/asp" => "clicks#create"
  
  devise_for :users

  root :to => "home#index"
end
