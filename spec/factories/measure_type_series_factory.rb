FactoryGirl.define do
  factory :measure_type_series do
    measure_type_series_id   { Forgery(:basic).text(exactly: 1) }
    validity_start_date      { Date.today.ago(3.years) }
    validity_end_date        { nil }

    trait :xml do
      measure_type_combination 0
      validity_end_date        { Date.today.ago(1.years) }
    end
  end

  factory :measure_type_series_description do
    measure_type_series_id { Forgery(:basic).text(exactly: 1) }
    description    { Forgery(:basic).text }

    trait :xml do
      language_id  { "EN" }
    end
  end
end
