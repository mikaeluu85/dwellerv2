class AddBashyraToLocations < ActiveRecord::Migration[7.2]
  def change
    add_column :locations, :bashyra, :decimal, precision: 10, scale: 2
  end
end
