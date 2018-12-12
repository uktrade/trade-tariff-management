class FootnoteAssociationMeasure < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  set_primary_key %i[measure_sid footnote_id footnote_type_id]
  plugin :oplog, primary_key: %i[measure_sid
                                 footnote_id
                                 footnote_type_id]
  plugin :conformance_validator

  one_to_one :footnote, key: :footnote_id,
                        primary_key: :footnote_id
  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  delegate :validity_start_date, :validity_end_date, to: :footnote, allow_nil: true
  delegate :validity_end_date, :validity_end_date, to: :footnote, allow_nil: true

  def record_code
    "430".freeze
  end

  def subrecord_code
    "20".freeze
  end
end
