class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer  :product_id,     :null => false
      
      t.timestamps
    end
  end
end
