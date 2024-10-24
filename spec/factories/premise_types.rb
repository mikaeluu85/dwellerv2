FactoryBot.define do
  factory :premise_type do
    sequence(:name) { |n| "Premise Type #{n}" }
    sequence(:slug) { |n| "premise-type-#{n}" }
  end
end
