class ProfilesController < ApplicationController
  # before_filter :authenticate_user!

  def new
  end

  def create
    _update_paypal_email('new')
  end

  def edit
    # @paypal_email = current_user.paypal_email
    @paypal_email = 'tester@example.org'
  end

  def update
    _update_paypal_email('edit')
  end

  def show
    logger.info 'Heelol'
    if current_user_has_paypal_email?
      redirect_to profile_new_path
    else
      current_user = User.first
      @paypal_email = current_user.primary_paypal_email
      # @paypal_email = 'tester@example.org'
    end
  end

  private
  # TODO : Error message on failure should be displayed with red background
  # TODO : This will be replaced with real implementation when Devise is integrated
  def _update_paypal_email(action)
    redirect_to root_path, :notice => "Successfully saved your payment settings."
    # current_user.primary_paypal_email = params[:primary_paypal_email]
    # if current_user.save
    #   redirect_to root_path, :notice => "Successfully saved your payment settings."
    # else
    #   flash[:error] = "Email format is invalid"
    #   render :action => action
    # end
  end
  
  def current_user_has_paypal_email?
    false
  end
end
