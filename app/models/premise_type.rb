class PremiseType < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :permutations
    has_many :locations, through: :permutations
  
    validates :name, presence: true
  
    after_create :generate_permutations
    
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
      ["locations", "permutations"]
    end

    def self.find_by_slug(slug)
      premise_type_slug, location_slug = slug.split('/')
      joins(:premise_type, :location)
        .where(premise_types: { slug: premise_type_slug }, locations: { slug: location_slug })
        .first
    end
  end