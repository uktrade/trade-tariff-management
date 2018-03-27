FactoryGirl.define do
  factory :measure_condition_code do
    condition_code { Forgery(:basic).text(exactly: 1) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :measure_condition_code_description do
    condition_code { Forgery(:basic).text(exactly: 1) }
    description    { Forgery(:basic).text }

    trait :xml do
      language_id  { "EN" }
    end
  end
end
