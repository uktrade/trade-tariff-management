class FootnoteTypeDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]
end


