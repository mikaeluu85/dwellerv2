FactoryBot.define do
  factory :provider_user do
    association :provider
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "provider_user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    mobile_phone { '+1234567890' }
    role { :editor }
  end
end
