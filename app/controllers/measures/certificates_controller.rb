module Measures
  class CertificatesController < ::Measures::BaseController

    def collection
      Certificate.actual
    end
  end
end

