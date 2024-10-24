FactoryBot.define do
  factory :listing do
    name { Faker::Company.name }
    area_description { 'Test Area' }
    commuter_description { 'Test Commuter' }
    size { 100 }
    status { :active }
    association :brand
  end
end
