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
  one_to_many :quota_unsuspension_events, key: :quota_definition_sid,
                                         primary_key: :quota_definition_sid
  one_to_many :quota_blocking_periods, key: :quota_definition_sid,
                                       primary_key: :quota_definition_sid

  one_to_one :quota_order_number, key: :quota_order_number_id,
                                  primary_key: :quota_order_number_id

  one_to_many :measures, key: [:ordernumber, :validity_start_date],
                         primary_key: [:quota_order_number_id, :validity_start_date]

  def measure
    @measure ||= measures.first
  end

  one_to_one :measurement_unit, key: :measurement_unit_code,
                                primary_key: :measurement_unit_code

  one_to_one :monetary_unit, key: :monetary_unit_code,
                             primary_key: :monetary_unit_code

  one_to_one :measurement_unit_qualifier, key: :measurement_unit_qualifier_code,
                                          primary_key: :measurement_unit_qualifier_code

  def event_status
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

  def last_unsuspension_event
    @_last_unsuspension_event ||= quota_unsuspension_events.last
  end

  def last_blocking_period
    @_last_blocking_period ||= quota_blocking_periods.last
  end

  def quota_type_id
    measure.measure_type_id if measure.present?
  end

  def regulation_id
    measure.measure_generating_regulation_id if measure.present?
  end

  def regulation_role
    measure.measure_generating_regulation_role if measure.present?
  end

  def reduction_indicator
    measure.reduction_indicator if measure.present?
  end

  def license
    if measure.present? && measure.measure_conditions.present?
      measure.measure_conditions.each do |condition|
        return condition.certificate_code if condition.certificate_code.present?
      end
      return nil
    end
  end

  def goods_nomenclature_item_ids
    if measures.present?
      measures.map do |measure|
        measure.goods_nomenclature_item_id
      end.select do |item|
        item.present?
      end.uniq
    else
      []
    end
  end

  def additional_code_ids
    if measures.present?
      measures.map do |measure|
        "#{measure.additional_code_type_id}#{measure.additional_code_id}"
      end.select do |item|
        item.present?
      end.uniq
    else
      []
    end
  end

  def quota_origin
    quota_order_number.quota_order_number_origin&.geographical_area_id
  end

  def origin_exclusions
    quota_order_number.quota_order_number_origin&.quota_order_number_origin_exclusions&.map do |exclusion|
      exclusion.geographical_area_id
    end
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
    if last_suspension_period.present? && last_suspension_period.status != :published
      I18n.t(:measures)[:states][last_suspension_period.status.to_sym]
    elsif status.present?
      I18n.t(:measures)[:states][status.to_sym]
    else
      "Published"
    end
  end

  def sent_to_cds?
    status.blank? || status.to_s.in?(::Workbaskets::Workbasket::SENT_TO_CDS_STATES)
  end

  def locked?
    (status.present? && status != :published) || (last_suspension_period.present? && last_suspension_period.status != :published)
  end

  def stopped?
    (workbasket.present? && workbasket.type == :bulk_edit_of_quotas && workbasket.settings.workbasket_action == 'stop_quota')
  end

  def to_json(options = {})
    {
        quota_definition_sid: quota_definition_sid,
        quota_order_number_id: quota_order_number_id.gsub(/^09/, '09.'),
        quota_type_id: quota_type_id,
        regulation_id: regulation_id,
        license: license || "-",
        validity_start_date: validity_start_date.try(:strftime, "%d %b %Y") || "-",
        validity_end_date: validity_end_date.try(:strftime, "%d %b %Y") || "Never (repeats)",
        goods_nomenclature_item_ids: goods_nomenclature_item_ids.join(', '),
        additional_code_ids: additional_code_ids.join(', '),
        origin: quota_origin,
        origin_exclusions: origin_exclusions&.join(', '),
        stopped: stopped?,
        locked: locked?,
        last_suspension_period: last_suspension_period&.to_json,
        last_unsuspension_event: last_unsuspension_event&.to_json,
        last_updated: (operation_date || added_at).try(:strftime, "%d %b %Y") || "-",
        status: status_title
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
