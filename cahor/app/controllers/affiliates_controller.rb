class AffiliatesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    affiliate = Affiliate.create(user_id: current_user.id)
    
    if affiliate.persisted?
      redirect_to welcome_path, :notice => 'You are now signed up as affiliate' 
    else
      render action: 'new'
    end
  end
end
