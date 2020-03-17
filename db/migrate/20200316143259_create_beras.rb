class CreateBeras < ActiveRecord::Migration[5.2]
  def change
    create_table :beras do |t|
      t.date :bra_date
      t.integer :risk1
      t.integer :risk2
      t.integer :evolrisk1
      t.integer :evolrisk2
      t.integer :altitude
      t.boolean :exposure_ne
      t.boolean :exposure_e
      t.boolean :exposure_s
      t.boolean :exposure_se
      t.boolean :exposure_sw
      t.boolean :exposure_n
      t.boolean :exposure_nw
      t.boolean :exposure_w
      t.text :comment
      t.integer :risk_max
      t.text :accidentel_text
      t.text :naturel_text
      t.references :mountain, foreign_key: true

      t.timestamps
    end
  end
end
