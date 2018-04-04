module Certificates
  class CertificatesController < ::BaseController

    def collection
      Certificate.actual
    end
  end
end
