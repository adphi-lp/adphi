class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.integer :brother_id
      t.belongs_to :signable, polymorphic: true
      t.integer :state, default: 0
      t.integer :position
      t.integer :category

      t.timestamps
    end

    add_index :signatures, [:signable_id, :signable_type]
  end
end
