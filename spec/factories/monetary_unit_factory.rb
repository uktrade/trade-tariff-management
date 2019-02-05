FactoryBot.define do
  factory :monetary_unit do
    monetary_unit_code { Forgery(:basic).text(exactly: 3) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_description do
      after(:create) { |monetary_unit, _evaluator|
        FactoryBot.create :monetary_unit_description, monetary_unit_code: monetary_unit.monetary_unit_code
      }
    end

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :monetary_unit_description do
    monetary_unit_code { Forgery(:basic).text(exactly: 3) }
    description        { Forgery(:basic).text }

    trait :xml do
      language_id { "EN" }
    end
  end

  factory :monetary_exchange_period do
    monetary_exchange_period_sid  { generate(:sid) }
    parent_monetary_unit_code     { Forgery(:basic).text(exactly: 2) }
    validity_start_date           { Date.today.ago(3.years) }
    validity_end_date             { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :monetary_exchange_rate do
    monetary_exchange_period_sid  { Forgery(:basic).number }
    child_monetary_unit_code      { Forgery(:basic).text(exactly: 2) }
    exchange_rate                 { Forgery(:basic).number }
  end
end
