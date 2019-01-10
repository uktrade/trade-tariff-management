module Certificates
  class CertificateTypesController < ::BaseController
    def collection
      CertificateType.q_search(params).eager(:certificate_type_description).all
    end
  end
end
