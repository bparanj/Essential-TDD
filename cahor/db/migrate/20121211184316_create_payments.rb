class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string   :transaction_id
      t.decimal  :gross,          :precision => 8, :scale => 2
      t.string   :currency
      t.decimal  :amount,         :precision => 8, :scale => 2
      t.string   :payment_method
      t.string   :description
      t.string   :status
      t.string   :test
      t.string   :payer_email
      t.string   :payment_date
      t.string   :payer_id
      t.text     :details
      t.integer  :invoice
      
      
      t.timestamps
    end
  end
end