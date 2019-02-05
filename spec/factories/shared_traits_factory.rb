FactoryBot.define do
  trait :for_upload_today do
    status { :awaiting_cds_upload_create_new }
    operation_date { Date.current }
  end
end
