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

  def parent_quota_number
    association = quota_order_number.sub_quota_associations.first
    association.parent_quota.quota_order_number_id if association.present? && association.parent_quota.present?
  end

  def sub_quota_number
    association = quota_order_number.parent_quota_associations.first
    association.sub_quota.quota_order_number_id if association.present? && association.sub_quota.present?
  end

  private

  def critical_state?
    critical_state == 'Y'
  end
end
