class AdditionalCode < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :additional_code_sid
  plugin :conformance_validator

  set_primary_key [:additional_code_sid]

  many_to_many :additional_code_descriptions, join_table: :additional_code_description_periods,
                                              left_key: :additional_code_sid,
                                              right_key: [:additional_code_description_period_sid,
                                                          :additional_code_sid] do |ds|
                                                ds.with_actual(AdditionalCodeDescriptionPeriod)
                                              end

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :additional_code_descriptions,
          additional_code_type_id: :additional_code_type_id,
          additional_code: :additional_code
        ).where("
          additional_codes.additional_code ilike ? OR
          additional_code_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      if filter_ops[:additional_code_type_id].present?
        scope = scope.where(
          "additional_codes.additional_code_type_id = ?", filter_ops[:additional_code_type_id]
        )
      end

      scope.order(Sequel.asc(:additional_codes__additional_code))
    end
  end

  def additional_code_description
    additional_code_descriptions(reload: true).first
  end

  one_to_one :meursing_additional_code, key: :additional_code,
                                        primary_key: :additional_code

  one_to_one :export_refund_nomenclature, key: :export_refund_code,
                                          primary_key: :additional_code

  delegate :description, :formatted_description, to: :additional_code_description

  def code
    "#{additional_code_type_id}#{additional_code}"
  end

  def record_code
    "245".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      additional_code: additional_code,
      type_id: additional_code_type_id,
      description: description
    }
  end

  def to_json(options = {})
    {
      additional_code: additional_code,
      type_id: additional_code_type_id,
      description: description
    }
  end
end
