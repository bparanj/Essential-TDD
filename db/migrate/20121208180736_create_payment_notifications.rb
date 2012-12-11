class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.text :details
      t.string :status
      t.string :transaction_id
      t.integer :invoice

      t.timestamps
    end
  end
end

