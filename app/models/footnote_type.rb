class FootnoteType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]

  one_to_many :footnotes

  one_to_one :footnote_type_description

  delegate :description, to: :footnote_type_description

  def record_code
    "100".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
