class User < ActiveRecord::Base
  include Clearance::User
  named_scope :affiliates, :joins => :affiliate, :conditions => { "users.is_affiliate" => true }
  
  belongs_to :referrer, :class_name => 'User', :foreign_key => 'referrer_user_id'
  has_one :affiliate
  has_many :payables
  has_many :payouts
  
  accepts_nested_attributes_for :affiliate
  
  validates_uniqueness_of :referrer_code, :on => :create
  before_validation :generate_referrer_code


  def before_validation
	  self.is_affiliate = true if self.affiliate
  end

  def self.generate_code
    rand(999999999999999).to_s(32).rjust(10,'0')
  end

  def generate_referrer_code
    return if self.referrer_code
    code = User.generate_code
    while User.find_by_referrer_code(code) != nil
      code = User.generate_code
    end
    self.referrer_code = code
  end

  def referral_url
	  "http://juiceinthecity.com/?referrer=#{referrer_code}"
  end
  alias :affiliate_url :referral_url

  def affiliate_iframe_large
		"<iframe frameborder='0' title='Juice in the City' height='350' src='http://ads.juiceinthecity.com/embeds/iframe/large?referrer=#{referrer_code}' id='jitc-deal' scrolling='no' width='300' name='jitc-deal'><br/></iframe><p style='font: 12px arial, verdana, helvetica, sans-serif; margin: 5 0 0 0'><a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com/?referrer=#{referrer_code}'  target='_blank'>Daily Deals</a> on <a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com?referrer=#{referrer_code}' target='_blank'>Juice in the City</a></p>"
  end

  def affiliate_iframe_medium
		"<iframe frameborder='0' title='Juice in the City' height='300' src='http://ads.juiceinthecity.com/embeds/iframe/medium?referrer=#{referrer_code}' id='jitc-deal' scrolling='no' width='250' name='jitc-deal'><br/></iframe><p style='font: 12px arial, verdana, helvetica, sans-serif; margin: 5 0 0 0'><a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com/?referrer=#{referrer_code}'  target='_blank'>Daily Deals</a> on <a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com?referrer=#{referrer_code}' target='_blank'>Juice in the City</a></p>"
  end

  def affiliate_iframe_small
		"<iframe frameborder='0' title='Juice in the City' height='230' src='http://ads.juiceinthecity.com/embeds/iframe/small?referrer=#{referrer_code}' id='jitc-deal' scrolling='no' width='150' name='jitc-deal'  target='_blank'><br/></iframe><p style='font: 12px arial, verdana, helvetica, sans-serif; margin: 5 0 0 0;'><a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com?referrer=#{referrer_code}' target='_blank'>Juice in the City</a></p>"
  end
  
  def affiliate_iframe_medium_rectangle
	  "<iframe frameborder='0' title='Juice in the City' height='250' src='http://ads.juiceinthecity.com/embeds/iframe/medium_rectangle?referrer=#{referrer_code}' id='jitc-deal' scrolling='no' width='300' name='jitc-deal'  target='_blank'><br/></iframe><p style='font: 12px arial, verdana, helvetica, sans-serif; margin: 5 0 0 0;'><a style='color: #c73981; text-decoration: none;' href='http://www.juiceinthecity.com?referrer=#{referrer_code}'  target='_blank'>Juice in the City</a></p>"
  end

end


def referral_link
  "http://www.juiceinthecity.com?referrer=#{current_user.referrer_code}"
end

class Affiliate < ActiveRecord::Base
  belongs_to :user
  has_one :payee, :through => :user
  
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
			redirect_to '/affiliates' if @user.affiliate?
		else
			redirect_to :action => "index"
		end
		@errors = ''
	end

	def create	        
		@user = User.find(params[:user][:id])
		@user.attributes = params[:user]
  
		if @user.save
			redirect_to confirmation_affiliates_url 
		else
			render :action => "new"
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

  add_index "affiliates", ["status_updated_by_user_id"], :name => "affiliates_status_updated_at_by_user_id"
  add_index "affiliates", ["user_id"], :name => "affiliates_user_id_unique", :unique => true

  create_table "payables",   :force => true do |t|
    t.integer  "user_id",                                             :null => false
    t.decimal  "amount",     :precision => 11, :scale => 2,           :null => false
    t.string   "status",     :default => "new", :null => false
    t.date     "due_on",                                              :null => false
    t.integer  "payout_id"
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account"
    t.string   "notes"
  end

  create_table "payment_refunds", :force => true do |t|
    t.integer  "refund_id",                                                               :null => false
    t.decimal  "amount",                :precision => 11, :scale => 2,                    :null => false
    t.integer  "payment_id",                                                              :null => false
    t.boolean  "voided_payment",                                       :default => false, :null => false
    t.boolean  "used_available_credit",                                :default => false, :null => false
    t.string   "status",                                               :default => "new", :null => false
    t.string   "notes"
    t.decimal  "payment_fee",           :precision => 11, :scale => 2
    t.decimal  "chargeback_reserve",    :precision => 11, :scale => 2
    t.decimal  "refund_fee",            :precision => 11, :scale => 2
    t.decimal  "referrer_share",        :precision => 11, :scale => 2
    t.decimal  "affiliate_share",       :precision => 11, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cc_transaction_id"
    t.string   "cc_last_4_digits"
    t.string   "cc_type"
  end

  add_index "payment_refunds", ["payment_id"], :name => "payment_refunds_payment_id"
  add_index "payment_refunds", ["refund_id"], :name => "payment_refunds_refund_id"

  create_table "payments", :force => true do |t|
    t.integer  "sale_id",                                                                 :null => false
    t.decimal  "amount",                :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                               :default => "new", :null => false
    t.string   "notes"
    t.decimal  "payment_fee",           :precision => 11, :scale => 2
    t.decimal  "chargeback_reserve",    :precision => 11, :scale => 2
    t.decimal  "referrer_share",        :precision => 11, :scale => 2
    t.decimal  "affiliate_share",       :precision => 11, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cc_last_4_digits"
    t.string   "cc_type"
    t.string   "cc_transaction_id"
    t.string   "cc_city"
    t.string   "cc_state"
    t.string   "cc_zip_code"
  end

  add_index "payments", ["sale_id"], :name => "payments_sale_id"

  create_table "payouts", :force => true do |t|
    t.integer  "user_id",                                                           :null => false
    t.decimal  "amount",          :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                         :default => "new", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refunds", :force => true do |t|
    t.integer  "sale_id",                                                        :null => false
    t.integer  "quantity",                                                       :null => false
    t.decimal  "refund_total", :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                      :default => "new", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
  end

  add_index "refunds", ["sale_id"], :name => "refunds_sale_id"
  add_index "refunds", ["status"], :name => "index_refunds_on_status"

  create_table "sales", :force => true do |t|
    t.integer  "buyer_user_id",                                                       :null => false
    t.integer  "deal_id",                                                             :null => false
    t.integer  "quantity",                                                            :null => false
    t.decimal  "deal_price",        :precision => 11, :scale => 2,                    :null => false
    t.decimal  "sale_total",        :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                           :default => "new", :null => false
    t.integer  "referrer_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                                                           :null => false
    t.boolean  "email_confirmed",                                                           :default => false,    :null => false
    t.datetime "email_confirmed_at"
    t.string   "encrypted_password",          :limit => 128
    t.string   "salt",                        :limit => 128
    t.string   "confirmation_token",          :limit => 128
    t.string   "remember_token",              :limit => 128
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_affiliate",                                                              :default => false,    :null => false
    t.datetime "last_visited_at"
    t.integer  "first_sale_id"
    t.integer  "last_sale_id"
    t.string   "referrer_code"
    t.decimal  "referrer_fee",                               :precision => 11, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "signed_up_at"
    t.integer  "referrer_user_id"
    t.string   "referrer_url"
    t.string   "referrer_host"
    t.string   "referrer_domain"
    t.string   "status",                                                                    :default => "active"
    t.string   "zip_code"
    t.datetime "status_updated_at"
    t.integer  "status_updated_by_user_id"
  end

  create_table "vendors", :force => true do |t|
    t.integer  "user_id",                                                 :null => false
    t.string   "business_name",                                           :null => false
    t.string   "business_url"
    t.decimal  "vendor_rate",               :precision => 4, :scale => 3
    t.integer  "vendor_installment_1_days"
    t.decimal  "vendor_installment_1_rate", :precision => 4, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
  end

  add_index "vendors", ["user_id"], :name => "index_vendors_on_user_id", :unique => true

  create_table "vouchers", :force => true do |t|
    t.integer  "sale_id"
    t.string   "code",                          :null => false
    t.datetime "revoked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deal_id",                       :null => false
    t.boolean  "used",       :default => false, :null => false
  end

end


