class AddBashyraToLocations < ActiveRecord::Migration[7.1]
  def change
    # Only add the column if it doesn't exist
    unless column_exists?(:locations, :bashyra)
      add_column :locations, :bashyra, :decimal, precision: 10, scale: 2
    end
  end
end
