class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer  :affiliate_id,   :null => false
      t.integer  :payable_id,   
      t.decimal  :product_price,      :precision => 11, :scale => 2, :null => false
      
      # DECISION: amount is calculated field based on commission rate
      # DECISION: commission rate is left to the seller and they will multiply it by that amount and make 
      # payment. So it is out of scope for now.
      
      t.timestamps
    end
  end
end