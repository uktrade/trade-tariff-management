class DutyExpression < Sequel::Model

  include ::XmlGeneration::BaseHelper

  MEURSING_DUTY_EXPRESSION_IDS = %w[12 14 21 25 27 29]

  plugin :time_machine
  plugin :oplog, primary_key: :duty_expression_id
  plugin :conformance_validator

  set_primary_key [:duty_expression_id]

  one_to_one :duty_expression_description

  delegate :abbreviation, :description, to: :duty_expression_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :duty_expression_descriptions,
          duty_expression_id: :duty_expression_id,
        ).where("
          duty_expressions.duty_expression_id ilike ? OR
          duty_expression_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:duty_expressions__duty_expression_id))
    end
  end

  def record_code
    "230".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      duty_expression_id: duty_expression_id,
      abbreviation: abbreviation,
      description: description
    }
  end
end
