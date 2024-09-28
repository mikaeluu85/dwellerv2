class CreateListingAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :listing_amenities do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
