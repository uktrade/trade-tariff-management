class MeasurementUnit < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :measurement_unit_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code]

  one_to_one :measurement_unit_description, primary_key: :measurement_unit_code,
                                            key: :measurement_unit_code

  delegate :description, to: :measurement_unit_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :measurement_unit_descriptions,
          measurement_unit_code: :measurement_unit_code,
        ).where("
          measurement_units.measurement_unit_code ilike ? OR
          measurement_unit_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:measurement_units__measurement_unit_code))
    end
  end

  def to_s
    description
  end

  def abbreviation(options={})
    measurement_unit_abbreviation(options).abbreviation
  rescue Sequel::RecordNotFound
    description
  end

  def measurement_unit_abbreviation(options={})
    measurement_unit_qualifier = options[:measurement_unit_qualifier]
    MeasurementUnitAbbreviation.where(
      measurement_unit_code: measurement_unit_code,
      measurement_unit_qualifier: measurement_unit_qualifier.try(:measurement_unit_qualifier_code)
    ).take
  end

  def record_code
    "210".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      measurement_unit_code: measurement_unit_code,
      description: description,
      abbreviation: abbreviation
    }
  end
end
