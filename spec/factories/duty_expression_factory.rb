FactoryBot.define do
  sequence(:duty_expression_description) { |n| n }

  factory :duty_expression do
    duty_expression_id  { generate(:duty_expression_description) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_description do
      duty_expression_description
    end

    trait :xml do
      duty_amount_applicability_code      { 0 }
      measurement_unit_applicability_code { 1 }
      monetary_unit_applicability_code    { 2 }
      validity_end_date                   { Date.today.ago(1.years) }
    end
  end

  factory :duty_expression_description do
    duty_expression_id  { generate(:duty_expression_description) }
    description         { Forgery(:basic).text }

    trait :xml do
      language_id { "EN" }
    end
  end
end
