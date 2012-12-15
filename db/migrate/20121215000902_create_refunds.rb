class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.string   :transaction_id
      t.string   :currency
      t.decimal  :amount,         :precision => 8, :scale => 2

      t.timestamps
    end
  end
end


