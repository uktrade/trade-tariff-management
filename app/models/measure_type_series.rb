class MeasureTypeSeries < Sequel::Model

  include ::XmlGeneration::BaseHelper

  set_primary_key [:measure_type_series_id]
  plugin :time_machine
  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  one_to_many :measure_types

  one_to_one :measure_type_series_description, key: :measure_type_series_id,
                                        foreign_key: :measure_type_series_id

  delegate :description, to: :measure_type_series_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:quota].present? && filter_ops[:quota] == "false"
        scope = scope.where(Sequel.~(measure_type_series_id: "N"))
      end

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measure_type_series_descriptions,
          measure_type_series_id: :measure_type_series_id
        ).where("
          measure_type_series.measure_type_series_id ilike ? OR
          measure_type_series_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:measure_type_series__measure_type_series_id))
    end
  end

  def record_code
    "140".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      oid: oid,
      measure_type_series_id: measure_type_series_id,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: description
    }
  end

  def to_json(options = {})
    json_mapping
  end
end
