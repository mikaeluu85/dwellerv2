class SearchContact < ApplicationRecord
  has_and_belongs_to_many :locations

  validates :office_type, inclusion: { in: %w(private coworking hybrid) }
  validates :number_of_workspaces, numericality: { greater_than: 0, only_integer: true }
  validates :company_name, :first_name, :last_name, presence: true
  validates :phone, presence: true, format: { with: /\A(?:\+46|0)(?:[1-9]\d{7,8}|[1-9]\d{1,2}-\d{6,7})\z/, message: "must be a valid Swedish phone number" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :validate_location_ids

  private

  def validate_location_ids
    return if location_ids.blank?
    invalid_ids = location_ids.reject { |id| Location.exists?(id) }
    errors.add(:location_ids, "contains invalid locations") if invalid_ids.any?
  end

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["company_name", "created_at", "email", "first_name", "id", "last_name", "number_of_workspaces", "office_type", "phone", "updated_at"]
  end

  # Define searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    ["locations"]
  end
end