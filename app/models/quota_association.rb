class QuotaAssociation < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[main_quota_definition_sid
                                 sub_quota_definition_sid]
  plugin :conformance_validator

  set_primary_key %i[main_quota_definition_sid sub_quota_definition_sid]

  many_to_one :main_quota_definition,
              key: :main_quota_definition_sid,
              class: QuotaDefinition

  many_to_one :sub_quota_definition,
              key: :sub_quota_definition_sid,
              class: QuotaDefinition

  def self.recent
    recent_sql = <<END_SQL
      SELECT qa.*, qd.quota_order_number_id 
      FROM quota_associations qa,
           quota_definitions qd 
      WHERE qa.status = 'published'
      AND qa.main_quota_definition_sid = qd.quota_definition_sid
      AND qd.validity_start_date >= now() - interval '2 year'
      ORDER BY qd.quota_order_number_id ASC, qd.validity_start_date DESC
END_SQL

    with_sql(recent_sql).all
  end

  def record_code
    "370".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
