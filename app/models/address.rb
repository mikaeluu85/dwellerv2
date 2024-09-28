# app/models/address.rb
class Address < ApplicationRecord
  belongs_to :listing
end