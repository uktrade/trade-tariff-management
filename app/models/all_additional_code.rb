class AllAdditionalCode < Sequel::Model

  include ::WorkbasketHelpers::Association

  dataset_module do
    include ::AdditionalCodes::SearchFilters::FindAdditionalCodesCollection
  end

  def code
    "#{additional_code_type_id}#{additional_code}"
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