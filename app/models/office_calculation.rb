# app/models/office_calculation.rb
class OfficeCalculation < ApplicationRecord
  belongs_to :location

  # JSON column to store steps 1-7 data
  attribute :steps_data, :json

  # Regular columns for step 8 (contact form)
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :company, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :terms_acceptance, acceptance: true

  # Validation for steps_data
  validate :validate_steps_data

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["id", "first_name", "last_name", "company", "email", "phone", "created_at", "updated_at", "terms_acceptance"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["location"]
  end

  private

  def validate_steps_data
    # Add validations for steps 1-7 data as needed
  end
end