FactoryGirl.define do
  sequence(:language_id) { |n| n }

  factory :language do
    language_id         { "EN" }
    validity_start_date { Date.today.ago(2.years) }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :language_description do
    language_code_id   { generate(:language_id) }
    language_id        { generate(:language_id) }
    description        { Forgery(:basic).text }
  end
end
