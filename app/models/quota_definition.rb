class QuotaDefinition < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  one_to_many :quota_exhaustion_events, key: :quota_definition_sid,
                                        primary_key: :quota_definition_sid

  one_to_many :quota_balance_events, key: :quota_definition_sid,
                                     primary_key: :quota_definition_sid
  one_to_many :quota_suspension_periods, key: :quota_definition_sid,
                                         primary_key: :quota_definition_sid
  one_to_many :quota_blocking_periods, key: :quota_definition_sid,
                                       primary_key: :quota_definition_sid

  one_to_one :quota_order_number, key: :quota_order_number_id,
                                  primary_key: :quota_order_number_id

  one_to_one :measurement_unit, key: :measurement_unit_code,
                                primary_key: :measurement_unit_code

  one_to_one :monetary_unit, key: :monetary_unit_code,
                             primary_key: :monetary_unit_code

  one_to_one :measurement_unit_qualifier, key: :measurement_unit_qualifier_code,
                                          primary_key: :measurement_unit_qualifier_code

  def status
    QuotaEvent.last_for(quota_definition_sid).status.presence || (critical_state? ? 'Critical' : 'Open')
  end

  def last_balance_event
    @_last_balance_event ||= quota_balance_events.last
  end

  def balance
    (last_balance_event.present?) ? last_balance_event.new_balance : volume
  end

  def last_suspension_period
    @_last_suspension_period ||= quota_suspension_periods.last
  end

  def last_blocking_period
    @_last_blocking_period ||= quota_blocking_periods.last
  end

  def record_code
    "370".freeze
  end

  def subrecord_code
    "00".freeze
  end

  dataset_module do
    include ::Quotas::SearchFilters::FindQuotasCollection
    include ::BulkEditHelpers::OrderByIdsQuery
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

  def to_json(options = {})
    {
        quota_definition_sid: quota_definition_sid,
        quota_order_number_id: quota_order_number_id,
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

  private

  def critical_state?
    critical_state == 'Y'
  end
end
