FactoryGirl.define do
  factory :regulation_group do
    regulation_group_id     { Forgery(:basic).text(exactly: 3) }
    validity_start_date     { Date.today.ago(2.years) }
    validity_end_date       { nil }

    trait :xml do
      validity_end_date     { Date.today.ago(1.years) }
    end
  end

  factory :regulation_group_description do
    regulation_group_id     { Forgery(:basic).text(exactly: 3) }
    language_id        { generate(:language_id) }
    description        { Forgery(:basic).text }
  end
end
