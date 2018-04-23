class RegulationGroup < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :regulation_group_id
  plugin :conformance_validator

  set_primary_key [:regulation_group_id]

  one_to_many :base_regulations

  one_to_one :regulation_group_description, key: :regulation_group_id,
                                            foreign_key: :regulation_group_id

  delegate :description, to: :regulation_group_description

  dataset_module do
    def q_search(keyword)
      q_rule = "#{keyword}%"

      join(
        :regulation_group_descriptions,
        regulation_group_id: :regulation_group_id
      ).where(
        "regulation_groups.regulation_group_id ilike ? OR
         regulation_group_descriptions.description ilike ?",
        q_rule,
        q_rule
      )
    end
  end

  def record_code
    "150".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      regulation_group_id: regulation_group_id,
      description: description
    }
  end
end
