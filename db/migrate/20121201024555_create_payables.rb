class CreatePayables < ActiveRecord::Migration
  def change
    create_table :payables do |t|
      t.integer  :affiliate_id, :null => false
      t.decimal  :amount,       :precision => 11, :scale => 2, :null => false
      t.string   :status,       :null => false, :default => "new" # "new", "paid" (final)
      t.integer  :product_id,   :null => false
      t.integer  :payout_id
      t.datetime :paid_at
      
      t.timestamps
    end

  end
end
