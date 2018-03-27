FactoryGirl.define do
  sequence(:modification_regulation_sid) { |n| n }

  factory :modification_regulation do
    modification_regulation_id   { generate(:sid) }
    modification_regulation_role { 4 }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :xml do
      validity_end_date                    { Date.today.ago(1.years) }
      published_date                       { Date.today.ago(2.years) }
      officialjournal_number               { "L 120" }
      officialjournal_page                 { 13 }
      base_regulation_role                 { Forgery(:basic).number }
      base_regulation_id                   { Forgery(:basic).text(exactly: 2) }
      replacement_indicator                { 0 }
      stopped_flag                         { 1 }
      information_text                     { "TR" }
      approved_flag                        { true }
      explicit_abrogation_regulation_role  { Forgery(:basic).number }
      explicit_abrogation_regulation_id    { Forgery(:basic).text(exactly: 2) }
      effective_end_date                   { Date.today.ago(1.years) }
      complete_abrogation_regulation_role  { Forgery(:basic).number }
      complete_abrogation_regulation_id    { Forgery(:basic).text(exactly: 2) }
    end
  end
end
