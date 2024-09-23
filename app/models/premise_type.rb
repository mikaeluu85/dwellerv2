class PremiseType < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :permutations
    has_many :locations, through: :permutations
  
    validates :name, presence: true
  
    after_create :generate_permutations
    
    private
  
    def generate_permutations
      Location.find_each do |location|
        Permutation.create!(location: location, premise_type: self)
      end
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