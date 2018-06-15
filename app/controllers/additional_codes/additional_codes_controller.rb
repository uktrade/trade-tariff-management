module AdditionalCodes
  class AdditionalCodesController < ::BaseController

    expose(:additional_code) do
      AdditionalCode.by_code(params[:code])
    end

    def collection
      AdditionalCode.q_search(params)
    end

    def preview
      if @nomenclature.present?
        render partial: "shared/tariff_breadcrumbs"
      else
        head :not_found
      end
    end
  end
end
