class CreatePayables < ActiveRecord::Migration
  def change
    create_table :payables do |t|
      t.integer  :affiliate_id, :null => false
      # amount is the total of all the bounties amount for the given start_date and end_date
      t.decimal  :amount,       :precision => 11, :scale => 2, :null => false
      t.string   :status,       :null => false, :default => "new" # "new", "paid" (final)
      t.integer  :payout_id
      
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :paid_at
      
      t.timestamps
    end

  end
end
