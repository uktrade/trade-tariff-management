class AdditionalCodeTypeDescription < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :additional_code_type_id
  plugin :conformance_validator

  set_primary_key [:additional_code_type_id]

  many_to_one :additional_code_type, key: :additional_code_type_id
  many_to_one :language

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description

  def record_code
    "120".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
