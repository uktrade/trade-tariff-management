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
    def q_search(keyword, additional_code_type_id=nil)
      q_rule = Sequel.ilike(:additional_code, "#{keyword}%")

      if additional_code_type_id.present?
        where(q_rule, Sequel.ilike(:additional_code_type_id, additional_code_type_id))
      else
        where(q_rule)
      end
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
end
