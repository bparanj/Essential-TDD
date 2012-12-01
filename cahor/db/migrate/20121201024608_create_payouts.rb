class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.integer  :affiliate_id,   :null => false
      t.decimal  :amount,         :precision => 11, :scale => 2, :null => false
      t.string   :status,         :null => false, :default => "new" # "new", "batched" (final)

      t.timestamps
    end
  end
end
