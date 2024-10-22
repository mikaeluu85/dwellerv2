# app/models/offer.rb
class Offer < ApplicationRecord
  self.inheritance_column = :_type_disabled
  acts_as_paranoid
  belongs_to :listing
  belongs_to :offer_category
  has_many :offer_versions
  has_many :offer_excluded_amenities
  has_many :excluded_amenities, through: :offer_excluded_amenities, source: :amenity
  has_many :offer_paid_amenities
  has_many :paid_amenities, through: :offer_paid_amenities, source: :amenity

  scope :active, -> { where(status: :active) }

  enum status: { active: 0, inactive: 1, pending: 2 }
  enum offer_type: { daily: 0, monthly: 1, yearly: 2 }

  validates :offer_category, presence: true

  validate :offer_category_valid_for_premise_type

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "listing_id", "name", "slug", "updated_at", "status", "type", "offer_category_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listing", "offer_category", "offer_excluded_amenities", "offer_paid_amenities", "offer_versions", "excluded_amenities", "paid_amenities"]
  end

  def category
    offer_category&.name
  end

  private

  def offer_category_valid_for_premise_type
    return if listing.nil? || offer_category.nil?

    unless listing.premise_type.offer_categories.include?(offer_category) || offer_category.name == 'Default Category'
      errors.add(:offer_category, "is not valid for this premise type")
    end
  end
end
