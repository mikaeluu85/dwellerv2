FactoryBot.define do
  factory :offer_category do
    sequence(:name) { |n| "Category #{n}" }

    trait :with_premise_types do
      transient do
        premise_types_count { 1 }
      end

      after(:create) do |offer_category, evaluator|
        offer_category.premise_types = create_list(:premise_type, evaluator.premise_types_count)
      end
    end
  end
end
