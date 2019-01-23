class QuotaBlockingPeriod < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :quota_definition_sid
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
end
