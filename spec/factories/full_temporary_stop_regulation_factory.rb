FactoryBot.define do
  factory :fts_regulation, class: FullTemporaryStopRegulation do
    full_temporary_stop_regulation_role   { Forgery(:basic).number }
    full_temporary_stop_regulation_id     { Forgery(:basic).text(exactly: 8) }
    validity_start_date                   { Time.now.ago(2.years) }
    validity_end_date                     { nil }
    effective_enddate                     { nil }

    trait :xml do
      officialjournal_number              { "L 120" }
      officialjournal_page                { 13 }
      replacement_indicator               { 0 }
      information_text                    { "TR" }
      approved_flag                       { true }

      explicit_abrogation_regulation_role { Forgery(:basic).number }
      explicit_abrogation_regulation_id   { Forgery(:basic).text(exactly: 8) }

      published_date                       { Date.today.ago(14.months) }
      effective_enddate                    { Date.today.ago(1.years) }
      validity_end_date                    { Date.today.ago(3.months) }
    end
  end

  factory :fts_regulation_action do
    fts_regulation_role     { Forgery(:basic).number }
    fts_regulation_id       { Forgery(:basic).text(exactly: 8) }
    stopped_regulation_role { Forgery(:basic).number }
    stopped_regulation_id   { Forgery(:basic).text(exactly: 8) }
  end
end
