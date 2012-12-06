class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer  :product_id,     :null => false
      t.string   :invoice
      t.text     :details
      t.string   :status
      t.string   :transaction_id
            
      t.timestamps
    end
  end
end
