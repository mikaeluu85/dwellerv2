class CreateBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :brands do |t|
      t.string :name
      t.references :provider, null: false, foreign_key: true
      t.boolean :has_active_listings
      t.string :cities
      t.text :description
      t.boolean :is_featured
      t.string :region
      t.string :slug
      t.integer :num_listings
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
