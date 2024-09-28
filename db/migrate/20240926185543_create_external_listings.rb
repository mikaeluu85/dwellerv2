class CreateExternalListings < ActiveRecord::Migration[7.2]
  def change
    create_table :external_listings do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :external_id
      t.string :source_url
      t.json :additional_data
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
