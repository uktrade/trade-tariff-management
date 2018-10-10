class ModificationRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::FormApiHelpers::RegulationSearch
  include ::RegulationDocumentContext
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: [:modification_regulation_id,
                               :modification_regulation_role]
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

  one_to_one :base_regulation, key: [:base_regulation_id, :base_regulation_role],
                               primary_key: [:base_regulation_id, :base_regulation_role]

  one_to_many :fts_regulations,
              class_name: :FullTemporaryStopRegulation,
              key: [ :full_temporary_stop_regulation_id,
                     :full_temporary_stop_regulation_role ]

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end

  def record_code
    "290".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def formatted_id
    year = Date.strptime(modification_regulation_id.slice(1,2), "%y").strftime("%Y");
    number = modification_regulation_id.slice(3,4)

    "#{year}/#{number}"
  end

  def last_fts_regulation
    fts_regulations.last
  end

  def to_json(options = {})
    {
      formatted_id: formatted_id,
      modification_regulation_id: modification_regulation_id,
      modification_regulation_role: modification_regulation_role,
      base_regulation_id: base_regulation_id,
      base_regulation_role: base_regulation_role,
      validity_start_date: validity_start_date.try(:strftime, "%d/%m/%Y"),
      validity_end_date: validity_end_date.try(:strftime, "%d/%m/%Y"),
      information_text: information_text,
      published_date: published_date.try(:strftime, "%d/%m/%Y"),
      officialjournal_number: officialjournal_number,
      officialjournal_page: officialjournal_page,
      effective_end_date: effective_end_date.try(:strftime, "%d/%m/%Y")
    }
  end
end
