FactoryBot.define do
  factory :brand do
    name { Faker::Company.name }
    sequence(:slug) { |n| "brand-#{n}" }
    active { true }
    association :provider
  end
end
