module Certificates
  class CertificateTypesController < ::BaseController

    def collection
      CertificateType.q_search(params)
    end
  end
end
