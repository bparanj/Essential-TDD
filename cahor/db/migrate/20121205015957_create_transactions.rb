class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :order_id
      t.string :transaction_id
      t.string :action
      t.integer :amount
      t.string  :currency
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :details

      t.timestamps
    end
  end
end