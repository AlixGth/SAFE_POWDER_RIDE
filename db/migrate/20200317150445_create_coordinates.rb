class CreateCoordinates < ActiveRecord::Migration[5.2]
  def change
    create_table :coordinates do |t|
      t.integer :altitude
      t.float :latitude
      t.float :longitude
      t.references :itinerary, foreign_key: true

      t.timestamps
    end
  end
end
