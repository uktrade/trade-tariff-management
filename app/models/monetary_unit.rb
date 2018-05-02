class MonetaryUnit < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :monetary_unit_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:monetary_unit_code]

  one_to_one :monetary_unit_description, key: :monetary_unit_code,
                                         primary_key: :monetary_unit_code

  delegate :description, :abbreviation, to: :monetary_unit_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :monetary_unit_descriptions,
          monetary_unit_code: :monetary_unit_code,
        ).where("
          monetary_units.monetary_unit_code ilike ? OR
          monetary_unit_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:monetary_units__monetary_unit_code))
    end
  end

  def to_s
    monetary_unit_code
  end

  def record_code
    "225".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      monetary_unit_code: monetary_unit_code,
      description: description,
      abbreviation: abbreviation
    }
  end
end
