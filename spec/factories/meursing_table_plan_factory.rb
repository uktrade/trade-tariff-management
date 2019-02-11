FactoryBot.define do
  factory :meursing_table_plan do
    meursing_table_plan_id          { Forgery(:basic).text(exactly: 2) }
    validity_start_date             { Date.today.ago(2.years) }
    validity_end_date               { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :meursing_table_cell_component do
    meursing_additional_code_sid  { generate(:sid) }
    meursing_table_plan_id        { Forgery(:basic).text(exactly: 2) }
    heading_number                { Forgery(:basic).number }
    row_column_code               { Forgery(:basic).number }
    subheading_sequence_number    { Forgery(:basic).number }
    additional_code               { Forgery(:basic).text(exactly: 2) }
    validity_start_date           { Date.today.ago(2.years) }
    validity_end_date             { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end
end
