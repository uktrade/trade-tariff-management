FactoryGirl.define do
  sequence(:base_regulation_sid) { |n| n }

  factory :base_regulation do
    base_regulation_id   { generate(:sid) }
    base_regulation_role { 1 }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
    effective_end_date  { nil }

    trait :abrogated do
      after(:build) { |br, evaluator|
        FactoryGirl.create(:complete_abrogation_regulation, complete_abrogation_regulation_id: br.base_regulation_id,
                                                            complete_abrogation_regulation_role: br.base_regulation_role)
      }
    end

    trait :xml do
      published_date                       { Date.today.ago(3.years) }
      validity_end_date                    { Date.today.ago(1.years) }
      effective_end_date                   { Date.today.ago(2.years) }
      community_code                       1
      regulation_group_id                  { Forgery(:basic).text(exactly: 3) }
      antidumping_regulation_role          { Forgery(:basic).number }
      related_antidumping_regulation_id    { generate(:sid) }
      complete_abrogation_regulation_role  { Forgery(:basic).number }
      complete_abrogation_regulation_id    { generate(:sid) }
      explicit_abrogation_regulation_role  { Forgery(:basic).number }
      explicit_abrogation_regulation_id    { generate(:sid) }
      stopped_flag                         1
      officialjournal_number               "L 120"
      officialjournal_page                 13
      replacement_indicator                0
      information_text                     "TR"
      approved_flag                        true
    end
  end
end
