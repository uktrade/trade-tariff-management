module Measures
  class CertificateTypesController < ::Measures::BaseController

    def collection
      CertificateType.actual
    end
  end
end

