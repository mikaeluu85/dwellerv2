class CreateLocations < ActiveRecord::Migration[7.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.json :geojson
      t.string :slug

      t.timestamps
    end
    add_index :locations, :slug, unique: true
  end
end
