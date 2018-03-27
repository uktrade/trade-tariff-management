class FootnoteAssociationMeasure < Sequel::Model

  include ::XmlGeneration::BaseHelper

  set_primary_key [:measure_sid, :footnote_id, :footnote_type_id]
  plugin :oplog, primary_key: [:measure_sid,
                               :footnote_id,
                               :footnote_type_id]
  plugin :conformance_validator

  one_to_one :footnote, key: :footnote_id,
                        primary_key: :footnote_id
  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  def record_code
    "430".freeze
  end

  def subrecord_code
    "20".freeze
  end
end
