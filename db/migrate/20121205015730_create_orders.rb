class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id
      t.string  :ip_address
      t.string  :first_name
      t.string  :last_name
      t.string  :express_token
      t.string  :express_payer_id
      t.text    :buyer_email
      t.text    :details
      
      t.timestamps
    end
  end
end
