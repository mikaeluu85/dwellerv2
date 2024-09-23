class Permutation < ApplicationRecord
  belongs_to :location
  belongs_to :premise_type

  validates :location_id, :premise_type_id, presence: true

  def to_param
    "#{premise_type.slug}/#{location.slug}" # This is for public-facing URLs
  end

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id", "location_id", "premise_type_id", "custom_data", "created_at", "updated_at"]
  end

  # Optionally, you can also define ransackable associations if needed
  def self.ransackable_associations(auth_object = nil)
    ["location", "premise_type"]
  end
end