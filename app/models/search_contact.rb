class SearchContact < ApplicationRecord
  has_and_belongs_to_many :locations

  validates :company_name, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :number_of_workspaces, presence: true, numericality: { greater_than: 0 }
  validates :office_type, presence: true

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["company_name", "created_at", "email", "first_name", "id", "last_name", "number_of_workspaces", "office_type", "phone", "updated_at"]
  end

  # Define searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    ["locations"]
  end
end