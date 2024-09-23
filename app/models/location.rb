class Location < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :permutations
    has_many :premise_types, through: :permutations
  
    validates :name, presence: true
    validates :geojson, presence: true
  
    # Add validation for prioritized if needed
    validates :prioritized, inclusion: { in: [true, false] }
  
    def contains_point?(latitude, longitude)
      factory = RGeo::GeoJSON::EntityFactory.instance
      point = factory.point(longitude, latitude)
      boundary = RGeo::GeoJSON.decode(geojson, json_parser: :json)
      
      boundary.contains?(point)
    end
  
    after_create :generate_permutations
    
    private
  
    def generate_permutations
      PremiseType.find_each do |premise_type|
        Permutation.create!(location: self, premise_type: premise_type)
      end
    end

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "slug", "geojson", "updated_at", "prioritized"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["premise_types", "permutations"]
    end
  end
