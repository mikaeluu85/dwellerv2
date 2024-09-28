class CreateOfferPaidAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :offer_paid_amenities do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
