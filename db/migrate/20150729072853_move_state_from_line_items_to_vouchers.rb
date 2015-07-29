class MoveStateFromLineItemsToVouchers < ActiveRecord::Migration
  def change
    remove_column :line_items, :state, :integer
    add_column :vouchers, :state, :integer, default: 0
  end
end
