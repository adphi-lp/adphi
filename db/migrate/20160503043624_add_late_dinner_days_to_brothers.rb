class AddLateDinnerDaysToBrothers < ActiveRecord::Migration
  def change
    add_column :brothers, :late_dinner_days, :text
  end
end
