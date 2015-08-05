class AddApprovedVoucherFieldsToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :paid_amount, :decimal
    add_column :vouchers, :approved_at, :datetime
    add_column :vouchers, :check_number, :string
  end
end
