FactoryGirl.define do
  sequence(:comment_sid) { |n| n }

  factory :transmission_comment do
    comment_sid    { generate(:comment_sid) }
    comment_text   { Forgery(:lorem_ipsum).sentence }

    trait :xml do
      language_id  { "EN" }
    end
  end
end
