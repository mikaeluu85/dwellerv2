# app/models/external_listing.rb
class ExternalListing < ApplicationRecord
  acts_as_paranoid

  # Define the associations that should be searchable
  def self.ransackable_associations(auth_object = nil)
    ["listing"] # Add any other associations you want to be searchable
  end

  # Define the attributes that should be searchable
  def self.ransackable_attributes(auth_object = nil)
    ["additional_data", "created_at", "deleted_at", "external_id", "id", "listing_id", "source_url", "updated_at"]
  end

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { only_deleted }
  
  belongs_to :listing
  validates :external_id, presence: true, uniqueness: true
end