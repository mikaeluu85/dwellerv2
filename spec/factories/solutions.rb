FactoryBot.define do
  factory :solution do
    association :listing
    size { rand(50..500) }
    workspaces { rand(1..50) }
    price { rand(1000.0..5000.0) }
    original_price { rand(1000.0..5000.0) }
    description { Faker::Lorem.paragraph }
    is_big_office { [ true, false ].sample }

    trait :with_rooms do
      after(:create) do |solution|
        create_list(:solution_room, 2, solution: solution)
      end
    end

    trait :with_thumbnail do
      after(:build) do |solution|
        solution.thumbnail.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
