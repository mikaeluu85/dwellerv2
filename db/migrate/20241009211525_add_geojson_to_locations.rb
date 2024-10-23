class AddGeojsonToLocations < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:locations, :geojson)
      add_column :locations, :geojson, :jsonb
      add_index :locations, :geojson, using: :gin
    end
  end
end