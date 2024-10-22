class Permutation < ApplicationRecord
  belongs_to :location
  belongs_to :premise_type

  validates :location_id, :premise_type_id, presence: true

  has_one_attached :header_image # For ActiveStorage

  # Validations (optional)
  validates :introduction, presence: true
  validates :in_depth_description, presence: true
  validates :commuter_description, presence: true

  def to_param
    "#{premise_type.slug}/#{location.slug}" # This is for public-facing URLs
  end

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id", "location_id", "premise_type_id", "custom_data", "created_at", "updated_at"]
  end

  # Optionally, you can also define ransackable associations if needed
  def self.ransackable_associations(auth_object = nil)
    ["location", "premise_type"]
  end

  def matching_offers
    # First get the offer IDs that match our criteria
    offer_ids = Offer.joins(:listing => :address)
                    .where(addresses: { city: location.name })
                    .where(offer_category_id: premise_type.offer_category_ids)
                    .where(status: :active)
                    .pluck(:id)

    # Then load those offers with their associations
    Offer.where(id: offer_ids)
         .preload(:listing)
         .preload(:offer_category)
  end

  def filtered_listings_with_offers
    # First get the listing IDs that match our criteria
    listing_ids = Listing.active
                        .joins(:address)
                        .joins(:offers)
                        .where(addresses: { city: location.name })
                        .where(offers: { 
                          status: :active,
                          offer_category_id: premise_type.offer_category_ids 
                        })
                        .distinct
                        .pluck(:id)

    # Then load those listings with their associations
    Listing.where(id: listing_ids)
           .preload(:address)
           .preload(offers: :offer_category)
  end
end
