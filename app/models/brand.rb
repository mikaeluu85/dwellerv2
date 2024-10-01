# app/models/brand.rb
class Brand < ApplicationRecord
  acts_as_paranoid
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :header_image
  has_one_attached :logo

  # Ensure these fields are defined in the database schema
  belongs_to :provider
  has_many :listings

  scope :active, -> { where(deleted_at: nil, active: true) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "is_featured", "name", "provider_id", "slug", "updated_at", "extended_description", "active"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "listings"]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  # Helper method to fetch active provider_users
  def active_provider_users
    provider&.provider_users&.active || ProviderUser.active
  end
end