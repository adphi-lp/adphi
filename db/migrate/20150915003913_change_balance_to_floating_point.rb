class ChangeBalanceToFloatingPoint < ActiveRecord::Migration
  def change
    change_column :balances, :value, :decimal
  end
end
