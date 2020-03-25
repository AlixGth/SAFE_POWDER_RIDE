class AddRiskToItineraries < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :risk, :integer
  end
end
