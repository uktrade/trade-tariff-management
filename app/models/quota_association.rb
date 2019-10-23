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

  def self.undo_deletion_by_workbasket!(workbasket_id:)
    undo_deletion_by_workbasket_sql = <<-SQL
      DELETE from quota_associations_oplog 
             where workbasket_id = :workbasket_id
             and operation = 'D';
    SQL

    @deleted_quota_association = Sequel::Model.db.fetch(undo_deletion_by_workbasket_sql, workbasket_id: workbasket_id).all
  end

  def record_code
    "370".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
