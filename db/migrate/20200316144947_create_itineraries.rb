class CreateItineraries < ActiveRecord::Migration[5.2]
  def change
    create_table :itineraries do |t|
      t.string :name
      t.integer :elevation
      t.string :departure
      t.string :arrival
      t.string :ascent_difficulty
      t.string :ski_difficulty
      t.text :description
      t.integer :duration
      t.references :mountain, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
