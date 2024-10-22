class OfferCategory < ApplicationRecord
  has_many :offers
  has_and_belongs_to_many :premise_types

  validates :name, presence: true, uniqueness: true

  # Add a method to check if a premise type is valid for this category
  def valid_for_premise_type?(premise_type)
    premise_types.include?(premise_type)
  end
end
