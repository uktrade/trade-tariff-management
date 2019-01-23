class FootnoteAssociationAdditionalCode < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[footnote_id
                                 footnote_type_id
                                 additional_code_sid]
  plugin :conformance_validator
  set_primary_key %i[footnote_id footnote_type_id additional_code_sid]

  def record_code
    "245".freeze
  end

  def subrecord_code
    "15".freeze
  end
end
