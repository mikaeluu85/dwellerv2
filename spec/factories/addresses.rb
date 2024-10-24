FactoryBot.define do
  factory :address do
    association :listing
    country { 'Sweden' }
    city { 'Stockholm' }
    street { Faker::Address.street_address }
    postal_code { Faker::Address.zip_code }
    postal_town { 'Stockholm' }

    # Add coordinates using PostGIS point type
    coordinates {
      RGeo::Geographic.spherical_factory(srid: 4326).point(18.0686, 59.3293) # Stockholm coordinates
    }

    trait :with_coordinates do
      latitude { 59.3293 }
      longitude { 18.0686 }
    end
  end
end
