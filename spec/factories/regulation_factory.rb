FactoryBot.define do
  factory :complete_abrogation_regulation do
    complete_abrogation_regulation_id   { generate(:sid) }
    complete_abrogation_regulation_role { Forgery(:basic).number }

    trait :xml do
      published_date          { Date.today.ago(2.years) }
      officialjournal_number  { "L 120" }
      officialjournal_page    { 13 }
      replacement_indicator   { 0 }
      information_text        { "TR" }
      approved_flag           { true }
    end
  end

  factory :explicit_abrogation_regulation do
    explicit_abrogation_regulation_id   { generate(:sid) }
    explicit_abrogation_regulation_role { Forgery(:basic).number }

    trait :xml do
      published_date          { Date.today.ago(2.years) }
      abrogation_date         { Date.today.ago(1.years) }
      officialjournal_number  { "L 120" }
      officialjournal_page    { 13 }
      replacement_indicator   { 0 }
      information_text        { "TR" }
      approved_flag           { true }
    end
  end

  factory :prorogation_regulation do
    prorogation_regulation_role { Forgery(:basic).number }
    prorogation_regulation_id   { generate(:sid) }

    trait :xml do
      published_date            { Date.today.ago(2.years) }
      officialjournal_number    { "L 120" }
      officialjournal_page      { 13 }
      replacement_indicator     { 0 }
      information_text          { "TR" }
      approved_flag             { true }
    end
  end

  factory :prorogation_regulation_action do
    prorogation_regulation_role { Forgery(:basic).number }
    prorogation_regulation_id   { generate(:sid) }
    prorogated_regulation_role  { Forgery(:basic).number }
    prorogated_regulation_id    { generate(:sid) }
    prorogated_date             { Date.today.ago(1.years) }
  end

  factory :regulation_replacement do
    replacing_regulation_role { Forgery(:basic).number }
    replacing_regulation_id   { generate(:sid) }
    replaced_regulation_role  { Forgery(:basic).number }
    replaced_regulation_id    { generate(:sid) }
    measure_type_id           { "490" }
    geographical_area_id      { generate(:sid) }
    chapter_heading           { Forgery(:basic).text(exactly: 3) }
  end

  factory :regulation_role_type do
    regulation_role_type_id   { generate(:sid) }
    validity_start_date       { Date.today.ago(2.years) }
    validity_end_date         { nil }

    trait :xml do
      validity_end_date       { Date.today.ago(1.years) }
    end
  end

  factory :regulation_role_type_description do
    regulation_role_type_id   { generate(:sid) }
    description               { Forgery(:lorem_ipsum).sentence }

    trait :xml do
      language_id             { "EN" }
    end
  end
end
