class AdditionalCodeDescription < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: %i[additional_code_description_period_sid additional_code_sid]
  plugin :conformance_validator

  set_primary_key %i[additional_code_description_period_sid additional_code_sid]

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description

  one_to_one :additional_code_description_period, key: %i[additional_code_description_period_sid additional_code_sid], primary_key: %i[additional_code_description_period_sid additional_code_sid]

  # many_to_one :language
  # many_to_one :additional_code_type, key: :additional_code_type_id
  # many_to_one :additional_code, key: :additional_code_sid
  def record_code
    "245".freeze
  end

  def subrecord_code
    "10".freeze
  end

  def to_json
    {
      description: description,
      validity_start_date: additional_code_description_period.validity_start_date.try(:strftime, "%d %b %Y") || "-"
    }
  end
end
