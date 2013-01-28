class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   :name,          :null => false
      t.decimal  :price,         :precision => 11, :scale => 2, :null => false
      t.integer  :user_id,       :null => false
      t.string   :file
      t.string   :thanks_page
      t.string   :cancel_page
      t.string   :sales_page
      t.string   :download_page
      
      t.timestamps
    end
  end
end
