class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer  :affiliate_id,   :null => false
      t.integer  :sale_id,        :null => false
      t.integer  :payable_id,     :null => false
      t.integer  :product_price,  :null => false
      # amount is calculated field based on commission
      
      t.timestamps
    end
  end
end


