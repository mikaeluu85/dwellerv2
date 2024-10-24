FactoryBot.define do
  factory :offer do
    association :listing
    association :offer_category
    sequence(:name) { |n| "Offer #{n}" }
    description { "Test description" }
    price { 100.0 }
    desk_type { "Standing" }
    nb_days { 30 }
    personal { false }
    area { 20.0 }
    max_seats { 4 }
    min_seats { 1 }
    terms { { "term1" => "value1" } }
    status { :active }
    offer_type { :monthly }
  end
end
