class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :voucher_id

      t.timestamps
    end
  end
end
