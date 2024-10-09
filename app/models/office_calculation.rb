# app/models/office_calculation.rb
class OfficeCalculation < ApplicationRecord
  belongs_to :location

  # JSON column to store steps 1-7 data
  attribute :steps_data, :jsonb

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

  # Class method to structure session data into nested steps data
  def self.structure_steps_data(session_data)
    Rails.logger.debug "Structuring steps data from session: #{session_data.inspect}"
    calculator_data = {}

    session_data.each do |key, value|
      next unless key.start_with?('calculator_')
      next if key == 'current_step'

      parts = key.split('_')
      step = parts[1]
      field = parts[2..].join('_')

      calculator_key = "calculator_#{step}"
      calculator_data[calculator_key] ||= {}
      calculator_data[calculator_key][field] = value  # Corrected line
    end

    Rails.logger.debug "Structured steps data: #{calculator_data.inspect}"
    calculator_data
  rescue StandardError => e
    Rails.logger.error "Error structuring steps data: #{e.message}"
    {}
  end

  private

  def validate_steps_data
    # Implement necessary validations for steps 1-7 data
    # Example:
    if steps_data.blank? || !steps_data.is_a?(Hash)
      errors.add(:steps_data, 'must be a valid JSON object with calculator steps.')
    end
    # Additional validations can be added here based on requirements
  end
end