# app/models/listing_user.rb
class ListingUser < ApplicationRecord
  belongs_to :listing
  belongs_to :provider_user
end