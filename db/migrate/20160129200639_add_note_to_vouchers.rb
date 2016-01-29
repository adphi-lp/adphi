class AddNoteToVouchers < ActiveRecord::Migration
  def change
  	add_column :vouchers, :note, :string
  end
end
