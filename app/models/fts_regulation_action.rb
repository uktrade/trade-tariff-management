class FtsRegulationAction < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: %i[fts_regulation_id
                                 fts_regulation_role
                                 stopped_regulation_id
                                 stopped_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[fts_regulation_id fts_regulation_role
                     stopped_regulation_id stopped_regulation_role]

  def record_code
    "300".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
