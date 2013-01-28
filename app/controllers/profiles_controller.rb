class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    _update_paypal_email('new')
  end

  def edit
    @paypal_email = current_user.primary_paypal_email
  end

  def update
    _update_paypal_email('edit')
  end

  def show
    if current_user.primary_paypal_email.nil?
      redirect_to profile_new_path
    else
      @paypal_email = current_user.primary_paypal_email
    end
  end

  private
  # TODO : Error message on failure should be displayed with red background
  def _update_paypal_email(action)
    current_user.primary_paypal_email = params[:primary_paypal_email]
    if current_user.save
      redirect_to root_path, :notice => "Successfully saved your payment settings."
    else
      flash[:error] = "Email format is invalid"
      render :action => action
    end
  end

end
