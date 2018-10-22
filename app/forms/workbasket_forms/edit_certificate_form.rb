module WorkbasketForms
  class EditCertificateForm

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :original_certificate,
                  :reason_for_changes,
                  :operation_date,
                  :description,
                  :description_validity_start_date,
                  :validity_start_date,
                  :validity_end_date

    def initialize(original_certificate)
      @original_certificate = original_certificate
    end

    def original_certificate_description
      original_certificate.description
    end
  end
end
