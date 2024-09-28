# app/models/offer.rb
class Offer < ApplicationRecord
  acts_as_paranoid
  belongs_to :listing
  has_many :offer_versions
  has_many :offer_excluded_amenities
  has_many :excluded_amenities, through: :offer_excluded_amenities, source: :amenity
  has_many :offer_paid_amenities
  has_many :paid_amenities, through: :offer_paid_amenities, source: :amenity
  
  enum status: [:active, :inactive, :pending]
  enum type: [:daily, :monthly, :yearly]
  enum category: [:hot_desk, :dedicated_desk, :private_office]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "listing_id", "name", "slug", "updated_at", "status", "type", "category"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listing", "offer_excluded_amenities", "offer_paid_amenities", "offer_versions", "excluded_amenities", "paid_amenities"]
  end
end
