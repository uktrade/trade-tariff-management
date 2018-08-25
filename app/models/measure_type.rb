class MeasureType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  IMPORT_MOVEMENT_CODES = [0, 2]
  EXPORT_MOVEMENT_CODES = [1, 2]
  EXCLUDED_TYPES = ['442', 'SPL']
  THIRD_COUNTRY = '103'

  plugin :time_machine, period_start_column: :measure_types__validity_start_date,
                        period_end_column:   :measure_types__validity_end_date
  plugin :oplog, primary_key: :measure_type_id
  plugin :conformance_validator

  set_primary_key [:measure_type_id]

  one_to_one :measure_type_description, key: :measure_type_id,
                                        foreign_key: :measure_type_id

  one_to_many :measures, key: :measure_type,
                         foreign_key: :measure_type_id

  many_to_one :measure_type_series

  many_to_many :additional_code_types, join_table: :additional_code_type_measure_types,
                                       class_name: 'AdditionalCodeType' do |ds|
                                         ds.with_actual(AdditionalCodeType)
                                       end

  delegate :description, to: :measure_type_description

  dataset_module do
    def by_measure_type_id(type_id)
      where(measure_type_id: type_id)
    end

    def national
      where(national: true)
    end

    def q_search(filter_ops)
      scope = actual

      if filter_ops[:quota].present? && filter_ops[:quota] == "true"
        scope = scope.where(order_number_capture_code: 1)
      elsif filter_ops[:quota].present? && filter_ops[:quota] == "false"
        scope = scope.where(Sequel.~(order_number_capture_code: 1))
      end

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measure_type_descriptions,
          measure_type_id: :measure_type_id
        ).where("
          measure_types.measure_type_id ilike ? OR
          measure_types.measure_type_acronym ilike ? OR
          measure_type_descriptions.description ilike ?",
          q_rule, q_rule, q_rule
        )
      end

      if filter_ops[:measure_type_series_id].present?
        scope = scope.where(
          measure_type_series_id: filter_ops[:measure_type_series_id]
        )
      end

      scope.order(Sequel.asc(:measure_types__measure_type_id))
    end
  end

  def id
    measure_type_id
  end

  def third_country?
    measure_type_id == THIRD_COUNTRY
  end

  def excise?
    !!(description =~ /EXCISE/)
  end

  def vat?
    !!(description =~ /^VAT/)
  end

  def record_code
    "235".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      oid: oid,
      measure_type_id: measure_type_id,
      measure_type_series_id: measure_type_series_id,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      valid: false,
      measure_type_acronym: measure_type_acronym,
      description: description
    }
  end

  def to_json(options = {})
    {
      measure_type_id: measure_type_id,
      measure_type_series: measure_type_series.to_json,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      measure_type_acronym: measure_type_acronym,
      description: description
    }
  end
end
