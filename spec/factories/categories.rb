FactoryBot.define do
    factory :category do
      name { Faker::Lorem.unique.word.capitalize }
      sequence(:slug) { |n| "category-#{n}" }
    end
  end