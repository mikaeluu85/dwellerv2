# app/models/room.rb
class Room < ApplicationRecord
  belongs_to :listing
  has_many :solution_rooms
  has_many :solutions, through: :solution_rooms

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "listing_id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listing", "solutions", "solution_rooms"]
  end
end
