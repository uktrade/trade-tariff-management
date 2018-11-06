class QuotaUnsuspensionEvent < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  def self.status
    'unsuspended'
  end

  def record_code
    "375".freeze
  end

  def subrecord_code
    "25".freeze
  end

  def status_title
    if status.present?
      I18n.t(:measures)[:states][status.to_sym]
    else
      "Published"
    end
  end

  def to_json
    {
        quota_definition_sid: quota_definition_sid,
        unsuspension_date: unsuspension_date.try(:strftime, "%d %b %Y") || "-",
        last_updated: (operation_date || added_at).try(:strftime, "%d %b %Y") || "-",
        status: status_title
    }
  end

end
