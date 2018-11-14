class Certificate < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

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

    begin :find_ceritificates_search_filters
      def default_order
        distinct(
          :certificates__certificate_type_code,
          :certificates__certificate_code
        ).order(
          Sequel.asc(:certificates__certificate_type_code),
          Sequel.asc(:certificates__certificate_code)
        )
      end

      def keywords_search(keyword)
        join_table(
          :inner,
          :certificate_descriptions,
          certificate_type_code: :certificate_type_code,
          certificate_code: :certificate_code
        ).where(
          "certificates.certificate_code ilike ? OR certificate_descriptions.description ilike ?",
          "#{keyword}%", "%#{keyword}%"
        )
      end

      def by_certificate_type_code(certificate_type_code)
        where("certificates.certificate_type_code = ?", certificate_type_code)
      end

      def by_certificate_code(certificate_code)
        where("certificates.certificate_code = ? ", certificate_code)
      end

      def after_or_equal(start_date)
        where("certificates.validity_start_date >= ?", start_date)
      end

      def before_or_equal(end_date)
        where(
          "certificates.validity_end_date IS NOT NULL AND certificates.validity_end_date <= ?", end_date
        )
      end
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

  delegate :description, to: :certificate_description, allow_nil: true

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

  def to_json(options = {})
    json_mapping
  end

  def decorate
    CertificateDecorator.decorate(self)
  end

  class << self
    def max_per_page
      10
    end

    def default_per_page
      10
    end

    def max_pages
      999
    end
  end
end
