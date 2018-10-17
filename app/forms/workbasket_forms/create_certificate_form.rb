# frozen_string_literal: true

module WorkbasketFroms
  class CreateCertificateForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :certificate_type_id,
                  :certificate_code,
                  :description,
                  :operation_date,
                  :validity_start_date,
                  :validity_end_date

    def certificate_types_list
      CertificateType.actual.map do |ft|
        {
          certificate_type_code: ft.certificate_type_code,
          description: ft.description
        }
      end.sort do |a, b|
        a[:certificate_type_code] <=> b[:certificate_type_code]
      end
    end
  end
end
