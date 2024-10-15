class Location < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :permutations
    has_many :premise_types, through: :permutations
    has_and_belongs_to_many :search_contacts

    validates :name, presence: true
    validates :geojson, presence: true
    validates :preposition, inclusion: { in: %w(i på), allow_nil: true } # Validate prepositions if needed

  
    # Add validation for prioritized if needed
    validates :prioritized, inclusion: { in: [true, false] }
  
    def contains_point?(latitude, longitude)
      factory = RGeo::GeoJSON::EntityFactory.instance
      point = factory.point(longitude, latitude)
      boundary = RGeo::GeoJSON.decode(geojson, json_parser: :json)
      
      boundary.contains?(point)
    end
  
    after_create :generate_permutations

    def full_description
      "#{preposition} #{name.titleize}".strip
    end

    def geojson
      parsed_geojson = read_attribute(:geojson)
      parsed_geojson.is_a?(String) ? JSON.parse(parsed_geojson) : parsed_geojson
    end
    
    private
  
    def generate_permutations
      PremiseType.find_each do |premise_type|
        Permutation.create!(
          location: self,
          premise_type: premise_type,
          introduction: "Default introduction for #{name} - #{premise_type.name}",
          in_depth_description: "Default in-depth description for #{name} - #{premise_type.name}",
          commuter_description: "Default commuter description for #{name} - #{premise_type.name}"
        )
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Failed to create permutation for Location #{id} and PremiseType #{premise_type.id}: #{e.message}"
      end
    end

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "slug", "geojson", "updated_at", "prioritized", "preposition", "bashyra"] # Ensure preposition is included
    end

    def self.ransackable_associations(auth_object = nil)
      ["premise_types", "permutations"]
    end

  end
