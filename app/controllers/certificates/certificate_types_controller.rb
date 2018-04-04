module Certificates
  class CertificateTypesController < ::BaseController

    def collection
      CertificateType.actual
    end
  end
end
