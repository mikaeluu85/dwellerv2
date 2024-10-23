class UpdateBrands < ActiveRecord::Migration[7.1]
  def change
    change_table :brands do |t|
      t.remove :region, :num_listings, :cities, :has_active_listings
      t.boolean :active, default: false
      t.text :extended_description
      t.references :header_image, foreign_key: { to_table: :active_storage_blobs }
      t.references :logo, foreign_key: { to_table: :active_storage_blobs }
    end
  end
end
