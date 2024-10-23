FactoryBot.define do
  factory :location do
    name { Faker::Address.city }
    sequence(:slug) { |n| "location-#{n}" }

    trait :in_stockholm do
      coordinates { create_point(18.0686, 59.3293) }
      geojson do
        {
          type: "Feature",
          properties: {},
          geometry: {
            type: "Point",
            coordinates: [ 18.0686, 59.3293 ]
          }
        }
      end
    end

    trait :in_gothenburg do
      coordinates { create_point(11.9746, 57.7089) }
      geojson do
        {
          type: "Feature",
          properties: {},
          geometry: {
            type: "Point",
            coordinates: [ 11.9746, 57.7089 ]
          }
        }
      end
    end
  end
end
