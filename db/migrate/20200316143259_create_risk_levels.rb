class CreateRiskLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_levels do |t|
      t.date :bra_date
      t.integer :risk1
      t.integer :risk2
      t.integer :evolrisk1
      t.integer :evolrisk2
      t.integer :altitude
      t.text :exposures, array: true, default: []
      t.integer :risk_max
      t.text :accidentel_text
      t.text :naturel_text

      t.timestamps
    end
  end
end
