# app/models/listing_amenity.rb
class ListingAmenity < ApplicationRecord
  belongs_to :listing
  belongs_to :amenity
end