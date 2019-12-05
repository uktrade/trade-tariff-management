class QuotaOrderNumber < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association
  include OwnValidityPeriod

  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_id,
                                primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition)
  end

  one_to_many :quota_definitions, key: :quota_order_number_id,
             primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition, nil, true)
  end

  one_to_one :measure, key: :ordernumber,
                       primary_key: :quota_order_number_id do |ds|
    ds.with_actual(Measure)
      .order(Sequel.desc(:validity_start_date))
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true

  dataset_module do
    def q_search(keyword)
      where {
        Sequel.ilike(:quota_order_number_id, "#{keyword}%")
      }
    end
  end

  def is_license_quota?
    quota_order_number_id.start_with?('094')
  end

  def record_code
    "360".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      quota_order_number_id: quota_order_number_id
    }
  end
end
