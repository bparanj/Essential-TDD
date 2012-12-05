class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      t.string :token
      t.string :express_token
      t.string :express_payer_id
      t.text :buyer_email
      
      t.timestamps
    end
  end
end
