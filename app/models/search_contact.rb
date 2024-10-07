class SearchContact < ApplicationRecord
  has_and_belongs_to_many :locations

  validates :company_name, :first_name, :last_name, :phone, :email, presence: true
  validates :number_of_workspaces, numericality: { greater_than: 0 }, allow_nil: true
  validates :office_type, inclusion: { in: %w[private coworking hybrid] }, allow_nil: true
end