
def referral_link
  "http://www.juiceinthecity.com?referrer=#{current_user.referrer_code}"
end

class Affiliate < ActiveRecord::Base
  belongs_to :user
  has_one :payee, :through => :user
  has_many :blogs, :through => :user

  def name
		if self.payee
			self.payee.business_name.blank? ? (self.payee.full_name.blank? ? self.user.name : self.payee.full_name) : self.payee.business_name
		else
			self.user.name
		end
  end

  def approved?
	  self.status.upcase == "APPROVED"
  end

  def new?
	  self.status.upcase == "NEW"
  end

  def rejected?
	  self.status.upcase == "REJECTED"
  end
  
  def after_create
    TransactionalMailer.deliver_affiliate_application_submission(self)
  end
  
end

class AffiliatesController < ApplicationController
  before_filter :authenticate
	ssl_required :all
	
	def index
		@user = current_user

    if @user.affiliate?
      render :action => 'show'
    else
      redirect_to :action => "new"
    end
	end

	def new
		if signed_in?
			@user = current_user
			@user.blogs.build if @user.blogs.empty?
			redirect_to '/affiliates' if @user.affiliate?
		else
			redirect_to :action => "index"
		end
		@errors = ''
	end

	def create
	  
	  @errors = Hash.new
	  
	  required = ['full_name', 'tin', 'street_1', 'city', 'state', 'zip_code', 'payee_type']
	  
	  for field in required
	    @errors[field] = '' if params[:user][:payee_attributes][field].blank?
    end
    
    
    if params[:user][:payee_attributes][:payee_type] == 'LLC' and params[:user][:payee_attributes][:llc_classification].blank?
      @errors['llc_classification'] = ''
    end
    @errors['terms'] = '' if !params[:user][:affiliate_terms] || params[:user][:affiliate_terms] == nil
  	  
	  if v = params.try(:[], :user).try(:[], :blogs_attributes).try(:[], 0).try(:[], :monthly_unique_visitor_count)
	    params[:user][:blogs_attributes][0][:monthly_unique_visitor_count] = v.gsub(",", "")
    end
      
      
		@user = User.find(params[:user][:id])
		if params.try(:[], :user).try(:[], :blogs_attributes).try(:[], 0).try(:[], :url).try(:blank?)
		  params[:user].delete(:blogs_attributes)
		end
		@user.attributes = params[:user]
		@user.password_optional = true
  
    if @errors and !@errors.blank?
      render :action => "new"
      @user.blogs.build if @user.blogs.empty?
		elsif @user.save
			redirect_to confirmation_affiliates_url 
		else
			render :action => "new"
			@user.blogs.build if @user.blogs.empty?
		end
	end

	def edit
		@user = current_user
	end

	def update
		@user = current_user
		@user.attributes = params[:user]
		@user.password_optional = true
		if @user.save
			TransactionalMailer.deliver_affiliate_info_update(@user)
			flash[:notice] = "Your information has been successfully saved."
			redirect_to affiliate_url(@user)
		else
			render :action => "new"
		end
	end

	def show
		@user = current_user
	end
	
  def earnings
 
  end

	def confirmation
	end

end

create_table "affiliates", :force => true do |t|
  t.integer  "user_id",                                                                     :null => false
  t.decimal  "affiliate_rate",            :precision => 3,  :scale => 3
  t.integer  "payout_days"
  t.decimal  "payout_minimum",            :precision => 11, :scale => 2
  t.string   "status",                                                   :default => "new", :null => false
  t.datetime "status_updated_at"
  t.integer  "status_updated_by_user_id"
  t.datetime "created_at"
  t.datetime "updated_at"
  t.decimal  "subscriber_referrer_fee",   :precision => 11, :scale => 2
  t.decimal  "payable_earnings",          :precision => 11, :scale => 2, :default => 0.0,   :null => false
  t.integer  "affiliate_subscriber_days"
end



