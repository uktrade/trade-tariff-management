class MeasureConditionCode < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :condition_code
  plugin :conformance_validator

  set_primary_key [:condition_code]

  one_to_one :measure_condition_code_description, key: :condition_code,
                                                  primary_key: :condition_code

  delegate :description, to: :measure_condition_code_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measure_condition_code_descriptions,
          condition_code: :condition_code,
        ).where("
          measure_condition_codes.condition_code ilike ? OR
          measure_condition_code_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:measure_condition_codes__condition_code))
    end
  end

  def record_code
    "350".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      condition_code: condition_code,
      description: description,
      valid: false # TODO: it seems that it just for testing purposes
    }
  end
end
