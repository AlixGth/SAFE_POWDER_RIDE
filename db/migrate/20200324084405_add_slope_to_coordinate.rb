class AddSlopeToCoordinate < ActiveRecord::Migration[5.2]
  def change
    add_column :coordinates, :slope, :float
  end
end
