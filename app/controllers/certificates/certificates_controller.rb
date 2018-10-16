module Certificates
  class CertificatesController < ::BaseController

    expose(:search_ops) do
      (params[:search || {}]).merge(
        page: params[:page]
      )
    end

    expose(:search_form) do
      CertificatesSearchForm.new(search_ops)
    end

    def collection
      Certificate.q_search(params)
    end

    def index
      render
    end
  end
end
