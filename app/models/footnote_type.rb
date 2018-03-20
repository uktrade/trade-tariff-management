class FootnoteType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]

  one_to_many :footnotes
end

