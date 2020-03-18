class AddCoordinateArrayToItineraries < ActiveRecord::Migration[5.2]
  def change
  	add_column :itineraries, :coordinates, :string, array: true, default: []
  end
end
