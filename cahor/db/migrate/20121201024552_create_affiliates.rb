class CreateAffiliates < ActiveRecord::Migration
  def change
    create_table :affiliates do |t|
		  t.integer :user_id,             :null => false
      t.string  :referrer_code
      
		  t.timestamps
	  end  	
  end
  
end
