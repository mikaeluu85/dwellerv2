FactoryBot.define do
  factory :listing do
    association :brand
    name { Faker::Company.name }
    size { rand(50..500) }
    cost_per_m2 { rand(100..1000) }
    cost_per_user { rand(500..5000) }
    surface_per_user { rand(5..20) }
    description { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    description_en { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    number_of_meeting_rooms { rand(1..10) }
    opened { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    status { :active }
    source { :internal }
  end
end
