class QuotaOrderNumber < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
end
