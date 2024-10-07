class AdvertiserContact < ApplicationRecord
  validates :company_name, :first_name, :last_name, :phone, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\d{8,}\z/, message: "måste vara minst 8 siffror" }

  # Define ransackable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["company_name", "org_number", "first_name", "last_name", "phone", "email", "created_at", "updated_at"]
  end

end
