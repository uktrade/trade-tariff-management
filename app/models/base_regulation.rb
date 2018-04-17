class BaseRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:base_regulation_id, :base_regulation_role]
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:base_regulation_id, :base_regulation_role]

  one_to_one :complete_abrogation_regulation, key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]


  dataset_module do
    def q_search(keyword)
      where {
        Sequel.ilike(:base_regulation_id, "%#{keyword}%") |
        Sequel.ilike(:information_text, "%#{keyword}%")
      }
    end

    def not_replaced_and_partially_replaced
      where("replacement_indicator = 0 OR replacement_indicator = 2")
    end
  end

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

  def json_mapping
    description = if effective_end_date.present?
      "#{base_regulation_id}: #{information_text} (#{validity_start_date.to_formatted_s(:uk)} to #{effective_end_date.to_formatted_s(:uk)})"
    else
      "#{base_regulation_id}: #{information_text} (#{validity_start_date.to_formatted_s(:uk)})"
    end

    {
      regulation_id: base_regulation_id,
      role: base_regulation_role,
      description: description
    }
  end
end
