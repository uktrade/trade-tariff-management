FactoryGirl.define do
  factory :workbasket, class: ::Workbaskets::Workbasket do
    title { "Test" }
    user_id { create(:user).id }

    trait :create_measures do
      type { :create_measures }
      status { :submitted_for_cross_check }
    end
  end
end
