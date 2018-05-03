class MeasurementUnitQualifier < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :measurement_unit_qualifier_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_qualifier_code]

  one_to_one :measurement_unit_qualifier_description, key: :measurement_unit_qualifier_code,
                                                      primary_key: :measurement_unit_qualifier_code

  delegate :formatted_measurement_unit_qualifier, :description, to: :measurement_unit_qualifier_description, allow_nil: true

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measurement_unit_qualifier_descriptions,
          measurement_unit_qualifier_code: :measurement_unit_qualifier_code,
        ).where("
          measurement_unit_qualifiers.measurement_unit_qualifier_code ilike ? OR
          measurement_unit_qualifier_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:measurement_unit_qualifiers__measurement_unit_qualifier_code))
    end
  end

  def record_code
    "215".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      measurement_unit_qualifier_code: measurement_unit_qualifier_code,
      description: description
    }
  end
end
