class QuotaBlockingPeriod < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  attr_accessor :added_at, :added_by_id, :national

  plugin :oplog, primary_key: :quota_blocking_period_sid
  plugin :conformance_validator

  set_primary_key [:quota_blocking_period_sid]

  dataset_module do
    def last
      order(Sequel.desc(:end_date)).first
    end
  end

  def record_code
    "370".freeze
  end

  def subrecord_code
    "10".freeze
  end

  def definition
    QuotaDefinition.find(quota_definition_sid: quota_definition_sid)
  end
end
