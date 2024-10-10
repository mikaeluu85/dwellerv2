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
  validates :phone, presence: true, format: { with: /\A(?:\+46|0)(?:[1-9]\d{1,2}[-\s]?)?\d{6,8}\z/, message: "must be a valid Swedish phone number" }
  validates :terms_acceptance, acceptance: true

  # Validation for steps_data
  validate :validate_step_1_fields

  # Sanitize the steps_data before saving
  before_save :sanitize_steps_data

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

  def validate_step_1_fields
    return unless steps_data.is_a?(Hash) && steps_data['calculator_1'].is_a?(Hash)

    step_1_data = steps_data['calculator_1']
    step_1_config = OFFICE_CALCULATOR_CONFIG['calculator_steps']['step_1']

    step_1_config&.each do |field, config|
      next if config.nil?
      value = step_1_data[field]

      if config['required'] && value.blank?
        errors.add(:steps_data, "#{config['question']} is required")
      elsif value.present?
        case config['input_type']
        when 'number'
          errors.add(:steps_data, "#{config['question']} must be a number") unless value.to_s =~ /\A\d+\z/
        end
      end
    end
  end

  def sanitize_steps_data
    return unless steps_data.is_a?(Hash)

    steps_data.each do |step, step_data|
      next unless step_data.is_a?(Hash)
      step_data.transform_values! do |value|
        case value
        when String
          ActionController::Base.helpers.sanitize(value)
        when Array
          value.map { |v| v.is_a?(String) ? ActionController::Base.helpers.sanitize(v) : v }
        else
          value
        end
      end
    end
  end

end