class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :voucher_id
      t.string :title
      t.decimal :amount

      t.timestamps
    end
  end
end
