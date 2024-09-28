# app/models/offer_paid_amenity.rb
class OfferPaidAmenity < ApplicationRecord
  belongs_to :offer
  belongs_to :amenity
end