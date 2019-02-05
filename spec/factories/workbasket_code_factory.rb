FactoryBot.define do
  factory :workbasket, class: ::Workbaskets::Workbasket do
    title { "Test" }
    user_id { create(:user).id }
    type { "create_measures" }

    trait :create_measures do
      type { :create_measures }
      status { :awaiting_cross_check }
    end
  end
end
