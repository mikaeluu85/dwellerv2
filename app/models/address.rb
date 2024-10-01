class Address < ApplicationRecord
  belongs_to :listing

  def full_address
    [street, city, postal_code, 'Sverige'].compact.join(', ')
  end
end