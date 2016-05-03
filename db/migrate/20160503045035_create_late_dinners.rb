class CreateLateDinners < ActiveRecord::Migration
  def change
    create_table :late_dinners do |t|
      t.integer :brother_id
      t.date :date

      t.timestamps
    end
  end
end
