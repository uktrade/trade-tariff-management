class AdditionalCode < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

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

    def by_code(code=nil)
      full_code = code.to_s
                      .delete(" ")
                      .downcase

      return nil unless (full_code.present? && full_code.size == 4)

      additional_code_type_id = full_code[0]
      additional_code = full_code[1..-1]

      scope = actual.where(additional_code: additional_code)

      if additional_code_type_id.present?
        scope = scope.where("lower(additional_code_type_id) = ?", additional_code_type_id)
      end

      scope.first
    end

    include ::AdditionalCodes::SearchFilters::FindAdditionalCodesCollection
    include ::BulkEditHelpers::OrderByIdsQuery
  end

  def additional_code_description
    additional_code_descriptions(reload: true).first
  end

  one_to_one :meursing_additional_code, key: :additional_code,
                                        primary_key: :additional_code

  one_to_one :export_refund_nomenclature, key: :export_refund_code,
                                          primary_key: :additional_code

  delegate :description, :formatted_description, to: :additional_code_description, allow_nil: true

  def code
    "#{additional_code_type_id}#{additional_code}"
  end

  def record_code
    "245".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def status_title
    if status.present?
      I18n.t(:measures)[:states][status.to_sym]
    else
      "Imported to TARIFF"
    end
  end

  def sent_to_cds?
    status.blank? || status.to_s.in?(::Workbaskets::Workbasket::SENT_TO_CDS_STATES)
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
      additional_code_sid: additional_code_sid,
      additional_code: additional_code,
      type_id: additional_code_type_id,
      formatted_code: code,
      description: description,
      validity_start_date: validity_start_date.try(:strftime, "%d %b %Y") || "-",
      validity_end_date: validity_end_date.try(:strftime, "%d %b %Y") || "-",
      operation_date: operation_date,
      workbasket: workbasket.try(:to_json),
      status: status_title,
      sent_to_cds: sent_to_cds?
    }
  end

  def to_table_json
    to_json
  end

  class << self
    def limit_per_page
      if Rails.env.production?
        300
      elsif Rails.env.development?
        30
      elsif Rails.env.test?
        10
      end
    end

    def max_per_page
      limit_per_page
    end

    def default_per_page
      limit_per_page
    end

    def max_pages
      999
    end
  end
end
