class AddEvolColorToCoordinates < ActiveRecord::Migration[5.2]
  def change
    add_column :coordinates, :evol_color, :string
  end
end
