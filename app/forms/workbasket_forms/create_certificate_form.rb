# frozen_string_literal: true

module WorkbasketForms
  class CreateCertificateForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :certificate_type_code,
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
      end.sort_by { |a| a[:certificate_type_code] }
    end
  end
end
