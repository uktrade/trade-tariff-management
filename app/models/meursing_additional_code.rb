class MeursingAdditionalCode < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: :meursing_additional_code_sid
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key  [:meursing_additional_code_sid]

  def code
    "7#{additional_code}"
  end

  def record_code
    "340".freeze
  end

  def subrecord_code
    "00".freeze
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
        additional_code_sid: meursing_additional_code_sid,
        additional_code: additional_code,
        type_id: '7',
        formatted_code: code,
        description: '',
        validity_start_date: validity_start_date.try(:strftime, "%d %b %Y") || "-",
        validity_end_date: validity_end_date.try(:strftime, "%d %b %Y") || "-",
        operation_date: operation_date,
        workbasket: workbasket.try(:to_json),
        additional_code_description: nil,
        status: status_title,
        sent_to_cds: sent_to_cds?
    }
  end

end
