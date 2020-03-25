class AddColumnToItineraries < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :length, :integer
    add_column :itineraries, :max_elevation, :integer
  end
end
