class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to root_path
    else
      redirect_to new_registrations_path
    end
  end
end
