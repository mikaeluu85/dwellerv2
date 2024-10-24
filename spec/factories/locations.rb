FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    sequence(:slug) { |n| "location-#{n}" }
    prioritized { false }
    geojson do
      {
        "type" => "FeatureCollection",
        "features" => [
          {
            "type" => "Feature",
            "properties" => {},
            "geometry" => {
              "coordinates" => [
                [
                  [ 17.576760005188135, 10.972739757738708 ],
                  [ 17.59560142193095, 10.88054387109814 ],
                  [ 17.68115998648659, 10.86052388219629 ],
                  [ 17.714518560392435, 10.934530464994367 ],
                  [ 17.576760005188135, 10.972739757738708 ]
                ]
              ],
              "type" => "Polygon"
            }
          }
        ]
      }
    end

    trait :prioritized do
      prioritized { true }
    end
  end
end
