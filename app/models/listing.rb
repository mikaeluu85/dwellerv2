# app/models/listing.rb
class Listing < ApplicationRecord
  acts_as_paranoid
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :brand, optional: true
  has_one :address
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
  
  enum status: [:active, :inactive, :pending]
  enum source: [:user_generated, :external, :imported]

  scope :external, -> { where(source: :external) }
  scope :user_generated, -> { where(source: :user_generated) }
  scope :with_brand, -> { where.not(brand_id: nil) }
  scope :without_brand, -> { where(brand_id: nil) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "name", "slug", "updated_at", "status", "source"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["address", "amenities", "brand", "external_listing", "geojson", "listings", "rooms", "solutions"]
  end
end
