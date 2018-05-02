class MeasureAction < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :action_code
  plugin :conformance_validator

  set_primary_key [:action_code]

  many_to_one :measure_action_description, key: :action_code,
                                           primary_key: :action_code

  delegate :description, to: :measure_action_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measure_action_descriptions,
          action_code: :action_code,
        ).where("
          measure_actions.action_code ilike ? OR
          measure_action_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:measure_actions__action_code))
    end
  end

  def record_code
    "355".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      action_code: action_code,
      description: description
    }
  end
end
