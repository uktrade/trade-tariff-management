class MeasureConditionCodeDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :condition_code
  plugin :conformance_validator

  set_primary_key [:condition_code]
end


