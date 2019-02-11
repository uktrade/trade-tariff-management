FactoryBot.define do
  sequence(:comment_sid) { |n| n }

  factory :transmission_comment do
    comment_sid    { generate(:comment_sid) }
    language_id    { "EN" }
    comment_text   { Forgery(:lorem_ipsum).sentence }
  end
end
