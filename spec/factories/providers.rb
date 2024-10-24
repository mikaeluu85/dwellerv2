FactoryBot.define do
  factory :provider do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    postal_code { "12345" }
    city { Faker::Address.city }
    invoice_notes { Faker::Lorem.paragraph }
    organizational_number { "123456-7890" }
    street { Faker::Address.street_address }
    invoice_email { Faker::Internet.email }
    contact_email { Faker::Internet.email }
    website { Faker::Internet.url }
    ovid { Faker::Alphanumeric.alpha(number: 10) }
    woid { Faker::Alphanumeric.alpha(number: 10) }

    trait :with_logo do
      after(:build) do |provider|
        provider.logo.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_logo.png')),
          filename: 'test_logo.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
