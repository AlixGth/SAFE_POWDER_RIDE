class CreateMountainRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :mountain_ranges do |t|
      t.string :name
      t.references :risk_level, foreign_key: true

      t.timestamps
    end
  end
end
