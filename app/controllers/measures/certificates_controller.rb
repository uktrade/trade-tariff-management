module Measures
  class CertificatesController < ::Measures::BaseController

    def collection
      Certificate.actual
                 .limit(100)
    end
  end
end

