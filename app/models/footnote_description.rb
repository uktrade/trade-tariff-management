class FootnoteDescription < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_description_period_sid,
                               :footnote_id,
                               :footnote_type_id]
  plugin :conformance_validator

  set_primary_key [:footnote_description_period_sid, :footnote_id, :footnote_type_id]

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description

  def record_code
   "200".freeze
  end

  def subrecord_code
   "10".freeze
  end
end
