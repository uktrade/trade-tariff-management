module Measures
  class CertificateTypesController < ::Measures::BaseController

    def collection
      CertificateType.actual
                     .limit(100)
    end
  end
end

