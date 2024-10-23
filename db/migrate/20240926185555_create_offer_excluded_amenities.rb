class CreateOfferExcludedAmenities < ActiveRecord::Migration[7.1]
  def change
    create_table :offer_excluded_amenities do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
