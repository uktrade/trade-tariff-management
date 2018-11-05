class QuotaSuspensionPeriod < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: :quota_suspension_period_sid
  plugin :conformance_validator

  set_primary_key [:quota_suspension_period_sid]

  dataset_module do
    def last
      order(Sequel.desc(:suspension_end_date)).first
    end
  end

  def record_code
    "370".freeze
  end

  def subrecord_code
    "15".freeze
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
        quota_suspension_period_sid: quota_suspension_period_sid,
        quota_definition_sid: quota_definition_sid,
        suspension_start_date: suspension_start_date.try(:strftime, "%d %b %Y") || "-",
        suspension_end_date: suspension_end_date.try(:strftime, "%d %b %Y") || "-",
        description: description,
        last_updated: (operation_date || added_at).try(:strftime, "%d %b %Y") || "-",
        status: status_title
    }
  end

end
