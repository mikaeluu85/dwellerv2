class CreateGeojsons < ActiveRecord::Migration[7.2]
  def change
    create_table :geojsons do |t|
      t.references :listing, null: false, foreign_key: true
      t.float :coordinates
      t.string :type

      t.timestamps
    end
  end
end
