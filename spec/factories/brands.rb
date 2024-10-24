FactoryBot.define do
  factory :brand do
    name { Faker::Company.name }
    sequence(:slug) { |n| "brand-#{n}" }
    association :provider
  end
end
