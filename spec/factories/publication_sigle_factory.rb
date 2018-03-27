FactoryGirl.define do
  factory :publication_sigle do
    code_type_id       { Forgery(:basic).text(exactly: 2) }
    code               { Forgery(:basic).text(exactly: 2) }
    publication_code   { Forgery(:basic).text(exactly: 1) }
    publication_sigle  { Forgery(:basic).text(exactly: 2) }
    validity_start_date   { Date.today.ago(2.years) }
    validity_end_date     { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end
end
