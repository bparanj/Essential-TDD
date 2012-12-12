class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string   :confirmation_number,           :limit => 15
      
      t.timestamps
    end
  end
end
