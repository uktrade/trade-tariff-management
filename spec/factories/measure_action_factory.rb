FactoryBot.define do
  factory :measure_action do
    action_code         { Forgery(:basic).text(exactly: 2) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :measure_action_description do
    action_code         { Forgery(:basic).text(exactly: 2) }
    description         { Forgery(:lorem_ipsum).sentence }

    trait :xml do
      language_id       { "EN" }
    end
  end
end
