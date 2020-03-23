class AddTerrainDifficultyToItinerary < ActiveRecord::Migration[5.2]
  def change
  	add_column :itineraries, :terrain_difficulty, :string
  end
end
