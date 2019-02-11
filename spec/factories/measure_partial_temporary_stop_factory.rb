FactoryBot.define do
  factory :measure_partial_temporary_stop do
    partial_temporary_stop_regulation_id { Forgery(:basic).text(exactly: 8) }
    measure_sid { generate(:measure_sid) }
    abrogation_regulation_id             { Forgery(:basic).text(exactly: 8) }
    validity_start_date                  { Time.now.ago(2.years) }
    validity_end_date                    { nil }

    trait :xml do
      partial_temporary_stop_regulation_officialjournal_number  { "L 120" }
      partial_temporary_stop_regulation_officialjournal_page    { 13 }
      abrogation_regulation_officialjournal_number              { "L 121" }
      abrogation_regulation_officialjournal_page                { 14 }
      validity_end_date                                         { Date.today.ago(1.years) }
    end
  end
end
