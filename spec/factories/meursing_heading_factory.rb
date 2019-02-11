FactoryBot.define do
  factory :meursing_heading do
    meursing_table_plan_id          { Forgery(:basic).text(exactly: 2) }
    meursing_heading_number         { Forgery(:basic).number }
    row_column_code                 { Forgery(:basic).number }
    validity_start_date             { Date.today.ago(2.years) }
    validity_end_date               { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :meursing_heading_text do
    meursing_table_plan_id    { Forgery(:basic).text(exactly: 2) }
    meursing_heading_number   { Forgery(:basic).number }
    row_column_code           { Forgery(:basic).number }
    description               { Forgery(:lorem_ipsum).sentence }

    trait :xml do
      language_id              { "EN" }
    end
  end

  factory :meursing_subheading do
    meursing_table_plan_id     { Forgery(:basic).text(exactly: 2) }
    meursing_heading_number    { Forgery(:basic).number }
    row_column_code            { Forgery(:basic).number }
    subheading_sequence_number { Forgery(:basic).number }
    description                { Forgery(:lorem_ipsum).sentence }
    validity_start_date        { Date.today.ago(2.years) }
    validity_end_date          { nil }

    trait :xml do
      validity_end_date        { Date.today.ago(1.years) }
    end
  end
end
