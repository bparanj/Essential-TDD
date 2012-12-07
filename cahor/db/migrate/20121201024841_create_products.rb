class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.decimal  :price,         :precision => 11, :scale => 2, :null => false
      t.string   :name,           :null => false
      t.integer  :user_id,        :null => false
      
      t.timestamps
    end
  end
end
