class BaseRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: [:base_regulation_id, :base_regulation_role]
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator
  plugin :dirty

  set_primary_key [:base_regulation_id, :base_regulation_role]

  include ::FormApiHelpers::RegulationSearch

  one_to_one :complete_abrogation_regulation,
             key: [ :complete_abrogation_regulation_id,
                    :complete_abrogation_regulation_role ]

  one_to_one :explicit_abrogation_regulation,
             key: [ :explicit_abrogation_regulation_id,
                    :explicit_abrogation_regulation_role ]

  one_to_many :generating_measures,
              class: :Measure,
              key: [ :measure_generating_regulation_id,
                     :measure_generating_regulation_role ] do |ds|
    ds.with_actual(Measure)
  end

  one_to_many :modification_regulations,
              key: [ :base_regulation_id,
                     :base_regulation_role ]

  many_to_one :regulation_group

  def not_completely_abrogated?
    complete_abrogation_regulation.blank?
  end

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end

  def record_code
    "285".freeze
  end

  def subrecord_code
    "00".freeze
  end

  #
  # TODO: probably we do not need this method as
  #       we had to use `measure.generating_regulation_code` instead
  #
  def formatted_id
    return "I9999/YY" if base_regulation_id == "IYY99990"

    year = Date.strptime(base_regulation_id.slice(1,2), "%y").strftime("%Y");
    number = base_regulation_id.slice(3,4)

    "#{year}/#{number}"
  end

  def to_json(options = {})
    {
      formatted_id: formatted_id,
      base_regulation_id: base_regulation_id,
      base_regulation_role: base_regulation_role,
      validity_start_date: validity_start_date.try(:strftime, "%d/%m/%Y"),
      validity_end_date: validity_end_date.try(:strftime, "%d/%m/%Y"),
      community_code: community_code,
      regulation_group_id: regulation_group_id,
      replacement_indicator: replacement_indicator,
      information_text: information_text,
      approved_flag: approved_flag,
      published_date: published_date.try(:strftime, "%d/%m/%Y"),
      officialjournal_number: officialjournal_number,
      officialjournal_page: officialjournal_page,
      effective_end_date: effective_end_date.try(:strftime, "%d/%m/%Y"),
    }
  end
end
