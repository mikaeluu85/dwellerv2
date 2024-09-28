# app/models/amenity.rb
class Amenity < ApplicationRecord
    acts_as_paranoid
    has_many :listing_amenities
    has_many :listings, through: :listing_amenities
    has_many :offer_excluded_amenities
    has_many :offer_paid_amenities

    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "deleted_at", "id", "name", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["listing_amenities", "listings", "offer_excluded_amenities", "offer_paid_amenities"]
    end
end