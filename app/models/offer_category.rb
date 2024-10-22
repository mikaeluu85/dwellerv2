class OfferCategory < ApplicationRecord
  has_many :offers
  has_and_belongs_to_many :premise_types

  validates :name, presence: true, uniqueness: true
end
