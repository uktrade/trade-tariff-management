class CertificateType < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: :certificate_type_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_type_code]

  many_to_one :certificate_type_description, key: :certificate_type_code,
                                             primary_key: :certificate_type_code,
                                             eager_loader_key: :certificate_type_code

  one_to_many :certificates, key: :certificate_type_code,
                             primary_key: :certificate_type_code

  delegate :description, to: :certificate_type_description

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :certificate_type_descriptions,
          certificate_type_code: :certificate_type_code,
        ).where("
          certificate_types.certificate_type_code ilike ? OR
          certificate_type_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      scope.order(Sequel.asc(:certificate_types__certificate_type_code))
    end
  end

  def record_code
    "110".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      certificate_type_code: certificate_type_code,
      description: description
    }
  end
end
