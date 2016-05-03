class CreateKeyValues < ActiveRecord::Migration
  def change
    create_table :key_values do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
