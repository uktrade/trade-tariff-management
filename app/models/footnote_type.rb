class FootnoteType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :time_machine
  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]

  one_to_many :footnotes

  one_to_one :footnote_type_description

  delegate :description, to: :footnote_type_description

  dataset_module do
    def q_search(keyword=nil)
      scope = actual

      if keyword.present?
        q_rule = "#{keyword}%"

        scope = scope.join_table(:inner,
          :footnote_type_descriptions,
          footnote_type_id: :footnote_type_id
        ).where("
          footnote_types.footnote_type_id ilike ? OR
          footnote_type_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:footnote_types__footnote_type_id))
    end
  end

  def record_code
    "100".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      footnote_type_id: footnote_type_id,
      description: description
    }
  end

  def to_json(options = {})
    {
      footnote_type_id: footnote_type_id,
      description: description
    }
  end
end
