FactoryBot.define do
    factory :admin_user do
      sequence(:email) { |n| "admin#{n}@example.com" }
      name { "Admin User" }
      password { "password123" }
      password_confirmation { "password123" }
    end
end
