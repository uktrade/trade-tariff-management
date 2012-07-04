class MonetaryExchangeRate < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :monetary_exchange_period, foreign_key: :monetary_exchange_period_sid
  belongs_to :child_monetary_unit, foreign_key: :child_monetary_unit_code,
                                   class_name: 'MonetaryUnit'
end
