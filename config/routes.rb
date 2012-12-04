Cahor::Application.routes.draw do
  
  get "affiliates/create"

  match "/welcome" => "welcome#index"
  match "/affiliate_signup" => "affiliates#create"
  
  devise_for :users

  root :to => "home#index"
end
