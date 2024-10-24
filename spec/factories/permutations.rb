FactoryBot.define do
  factory :permutation do
    association :location
    association :premise_type
    introduction { "Default introduction" }
    in_depth_description { "Default in-depth description" }
    commuter_description { "Default commuter description" }
  end
end
