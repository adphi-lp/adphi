class AddDateOfficerStateToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :purchase_date, :date
    add_column :line_items, :budget_type, :integer
    add_column :line_items, :state, :integer
  end
end
