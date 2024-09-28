# app/models/provider_user.rb
class ProviderUser < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  
  enum role: [:editor, :administrator]
  
  belongs_to :provider
  has_many :listing_users
  has_many :listings, through: :listing_users
  has_many :offers

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "email", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "role", "provider_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "listings", "offers"]
  end
end
