class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.integer :brother_id
      t.string :title

      t.timestamps
    end
  end
end
