class Certificate < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:certificate_code, :certificate_type_code]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_code, :certificate_type_code]

  many_to_many :certificate_descriptions, join_table: :certificate_description_periods,
                                          left_key: [:certificate_code, :certificate_type_code],
                                          right_key: :certificate_description_period_sid do |ds|
    ds.with_actual(CertificateDescriptionPeriod)
      .order(Sequel.desc(:certificate_description_periods__validity_start_date))
  end

  dataset_module do
    def q_search(filter_ops)
      scope = actual

      if filter_ops[:q].present?
        q_rule = "#{filter_ops[:q]}%"

        scope = scope.join_table(:inner,
          :certificate_descriptions,
          certificate_type_code: :certificate_type_code,
          certificate_code: :certificate_code
        ).where("
          certificates.certificate_code ilike ? OR
          certificate_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      if filter_ops[:certificate_type_code].present?
        scope = scope.where(
          "certificates.certificate_type_code = ?", filter_ops[:certificate_type_code]
        )
      end

      scope.order(Sequel.asc(:certificates__certificate_code))
    end
  end

  def certificate_description
    certificate_descriptions(reload: true).first
  end

  one_to_many :certificate_types, key: :certificate_type_code,
                                  primary_key: :certificate_type_code do |ds|
    ds.with_actual(CertificateType)
  end

  def certificate_type
    certificate_types(reload: true).first
  end

  delegate :description, to: :certificate_description

  def record_code
   "205".freeze
  end

  def subrecord_code
   "00".freeze
  end

  def json_mapping
    {
      certificate_code: certificate_code,
      description: description
    }
  end
end
