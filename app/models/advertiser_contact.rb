class AdvertiserContact < ApplicationRecord
  validates :company_name, :first_name, :last_name, :phone, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\d{8,}\z/, message: "måste vara minst 8 siffror" }
end
