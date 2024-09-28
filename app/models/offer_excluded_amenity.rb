# app/models/offer_excluded_amenity.rb
class OfferExcludedAmenity < ApplicationRecord
  belongs_to :offer
  belongs_to :amenity
end