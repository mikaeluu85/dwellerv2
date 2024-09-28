# app/models/solution.rb
class Solution < ApplicationRecord
  belongs_to :listing
  has_many :solution_rooms, dependent: :destroy # Ensure this association exists
  accepts_nested_attributes_for :solution_rooms, allow_destroy: true
  has_many :rooms, through: :solution_rooms
  has_one_attached :thumbnail

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "listing_id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listing", "rooms", "solution_rooms"]
  end
end
