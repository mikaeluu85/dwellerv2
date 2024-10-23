class PremiseType < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :permutations
    has_many :locations, through: :permutations
    has_and_belongs_to_many :offer_categories
  
    validates :name, presence: true
  
    after_create :generate_permutations
    
    # Add this method to allow ActiveAdmin to assign offer categories
    def offer_category_ids=(ids)
      self.offer_categories = OfferCategory.where(id: ids)
    end
    
    # Make this method public
    def offer_category_names
      offer_categories.pluck(:name)
    end
    
    private
  
    def generate_permutations
      Rails.logger.info "Starting to generate permutations for PremiseType: #{id}"
      location_count = Location.count
      Rails.logger.info "Total locations: #{location_count}"

      Location.find_each do |location|
        begin
          permutation = Permutation.new(location: location, premise_type: self)
          permutation.save(validate: false)
          Rails.logger.info "Created permutation for Location: #{location.id}"
        rescue => e
          Rails.logger.error "Error creating permutation for Location: #{location.id}. Error: #{e.message}"
        end
      end

      Rails.logger.info "Finished generating permutations for PremiseType: #{id}"
    end

    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "slug", "created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["locations", "permutations", "offer_categories"]
    end

    def self.find_by_slug(slug)
      premise_type_slug, location_slug = slug.split('/')
      joins(:premise_type, :location)
        .where(premise_types: { slug: premise_type_slug }, locations: { slug: location_slug })
        .first
    end

    # Add a method to check if an offer's category is valid for this premise type
    def valid_offer_category?(offer_category)
      offer_category_ids.include?(offer_category.id)
    end

    def valid_offer?(offer)
      valid_offer_category?(offer.offer_category)
    end

    def filter_valid_offers(offers)
      offers.where(offer_category_id: offer_category_ids)
    end

    # Scopes
    scope :with_prioritized_locations, -> { 
      joins(:locations)
        .where(locations: { prioritized: true })
        .distinct 
    }
    
    scope :ordered_by_name, -> { order(:name) }
end
