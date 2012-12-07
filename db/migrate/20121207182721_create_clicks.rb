class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :affiliate_id
      t.integer :product_id
      t.integer :landing_page_id
      t.string  :referral_cookie
      t.string  :domain
      t.string  :ip_address
      t.string  :referral_code
      t.string  :payer_cookie

      t.timestamps
    end
  end
end
