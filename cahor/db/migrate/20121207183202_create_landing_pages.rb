class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.text :link
      t.string :name, :default => "", :null => false
      t.references :product
      
      t.timestamps
    end
  end
end
