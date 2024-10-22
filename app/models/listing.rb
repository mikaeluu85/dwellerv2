# app/models/listing.rb
class Listing < ApplicationRecord
  acts_as_paranoid
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :brand, optional: true
  has_one :address, dependent: :destroy
  has_one :geojson
  has_one :external_listing
  has_many :solutions
  has_many :rooms
  has_many :offers
  has_many :listing_users
  has_many :provider_users, through: :listing_users
  has_many :listing_amenities
  has_many :amenities, through: :listing_amenities
  has_one_attached :main_image
  has_many_attached :gallery_images
  
  enum status: { active: 0, inactive: 1, pending: 2 }
  enum source: { user_generated: 0, external: 1, imported: 2 }

  scope :external, -> { where(source: :external) }
  scope :user_generated, -> { where(source: :user_generated) }
  scope :with_brand, -> { where.not(brand_id: nil) }
  scope :without_brand, -> { where(brand_id: nil) }
  scope :active, -> { where(status: :active) }

  def self.ransackable_attributes(auth_object = nil)
    [
      "area_description", "brand_id", "commuter_description", "conference_room_request_email",
      "cost_per_m2", "cost_per_user", "created_at", "deleted_at", "description",
      "description_en", "id", "is_premium_listing", "name", "number_of_meeting_rooms",
      "opened", "short_description", "short_description_en", "showing_message", "size",
      "slug", "source", "status", "surface_per_user", "updated_at", "url"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["address", "amenities", "brand", "external_listing", "geojson", "listings", "rooms", "solutions", "provider_users"]
  end

  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :offers, allow_destroy: true

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  # Optional: Add validations
  validates :area_description, presence: true
  validates :commuter_description, presence: true

  def coordinates
    address&.coordinates_array
  end

  def latitude
    address&.latitude
  end

  def longitude
    address&.longitude
  end

  def valid_offers_for_premise_type(premise_type)
    offers.active.where(offer_category_id: premise_type.offer_category_ids)
  end

end
