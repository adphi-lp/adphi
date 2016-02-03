class RemoveBrothersPositionAndAddPositions < ActiveRecord::Migration
  def change
    remove_column :brothers, :position
    add_column :brothers, :positions, :text
  end
end
