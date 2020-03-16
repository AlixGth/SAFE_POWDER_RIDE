class CreateItineraries < ActiveRecord::Migration[5.2]
  def change
    create_table :itineraries do |t|
      t.string :name
      t.references :mountain_range, foreign_key: true
      t.integer :elevation
      t.text :departure
      t.text :arrival
      t.string :ascent_difficulty
      t.string :ski_difficulty
      t.text :description
      t.time :duration

      t.timestamps
    end
  end
end
