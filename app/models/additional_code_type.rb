class AdditionalCodeType < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include OwnValidityPeriod

  plugin :time_machine, period_start_column: :additional_code_types__validity_start_date,
                        period_end_column:   :additional_code_types__validity_end_date
  plugin :oplog, primary_key: :additional_code_type_id
  plugin :conformance_validator

  set_primary_key [:additional_code_type_id]

  one_to_many :additional_codes, key: :additional_code_type_id
  one_to_one  :additional_code_type_description, key: :additional_code_type_id
  one_to_many :additional_code_descriptions, key: :additional_code_type_id
  one_to_many :additional_code_type_measure_types
  many_to_many :measure_types, join_table: :additional_code_type_measure_types
  one_to_many :additional_code_description_periods, key: :additional_code_type_id
  one_to_many :footnote_association_additional_codes, key: :additional_code_type_id
  many_to_many :footnotes, join_table: :footnote_association_additional_codes,
                           class_name: 'Footnote'
  one_to_many :export_refund_nomenclatures, primary_key: :additional_code_type_id,
                                            key: :additional_code_type

  many_to_one :meursing_table_plan

  delegate :present?, to: :meursing_table_plan, prefix: true, allow_nil: true

  delegate :description, :formatted_description, to: :additional_code_type_description, allow_nil: true

  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Export refund for processed agricultural goods"
  }.freeze

  def meursing?
    application_code.present? && application_code.in?("3")
  end

  def non_meursing?
    !meursing?
  end

  def export_refund?
    application_code == "0"
  end

  def export_refund_agricultural?
    application_code == "4"
  end

  def record_code
    "120".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      additional_code_type_id: additional_code_type_id,
      description: description
    }
  end

  class << self
    def export_refund_for_processed_agricultural_goods_type_ids
      where(application_code: "4").pluck(:additional_code_type_id)
    end
  end
end
