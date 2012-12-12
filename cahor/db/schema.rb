# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121212192714) do

  create_table "affiliates", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.string   "referrer_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "bounties", :force => true do |t|
    t.integer  "affiliate_id",           :null => false
    t.integer  "paypal_notification_id", :null => false
    t.integer  "payable_id",             :null => false
    t.integer  "product_price",          :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "clicks", :force => true do |t|
    t.integer  "affiliate_id"
    t.integer  "product_id"
    t.integer  "landing_page_id"
    t.string   "referral_cookie"
    t.string   "domain"
    t.string   "ip_address"
    t.string   "referral_code"
    t.string   "payer_cookie"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "landing_pages", :force => true do |t|
    t.text     "link"
    t.string   "name",       :default => "", :null => false
    t.integer  "product_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "product_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.text     "buyer_email"
    t.text     "details"
    t.string   "number",           :limit => 15
    t.string   "status",                         :default => "open"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "payables", :force => true do |t|
    t.integer  "affiliate_id",                                                   :null => false
    t.decimal  "amount",       :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                      :default => "new", :null => false
    t.integer  "payout_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "paid_at"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "payment_notifications", :force => true do |t|
    t.text     "details"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "invoice"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "payments", :force => true do |t|
    t.string   "transaction_id"
    t.decimal  "gross",          :precision => 8, :scale => 2
    t.string   "currency"
    t.decimal  "amount",         :precision => 8, :scale => 2
    t.string   "payment_method"
    t.string   "description"
    t.string   "status"
    t.string   "test"
    t.string   "payer_email"
    t.string   "payment_date"
    t.string   "payer_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "payouts", :force => true do |t|
    t.integer  "affiliate_id",                                                   :null => false
    t.decimal  "amount",       :precision => 11, :scale => 2,                    :null => false
    t.string   "status",                                      :default => "new", :null => false
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "products", :force => true do |t|
    t.decimal  "price",      :precision => 11, :scale => 2, :null => false
    t.string   "name",                                      :null => false
    t.integer  "user_id",                                   :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "tokens", :force => true do |t|
    t.string   "confirmation_number", :limit => 15
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "details"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "primary_paypal_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
