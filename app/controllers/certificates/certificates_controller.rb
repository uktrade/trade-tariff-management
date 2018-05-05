module Certificates
  class CertificatesController < ::BaseController

    def collection
      Certificate.q_search(params)
    end
  end
end
