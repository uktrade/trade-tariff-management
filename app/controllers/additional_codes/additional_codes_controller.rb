module AdditionalCodes
  class AdditionalCodesController < ::BaseController

    expose(:additional_code) do
      AdditionalCode.by_code(params[:code])
    end

    expose(:items_search) do
      []
    end

    #TODO: disclaimer: this is a hack so I can work on the UI :). I think we should have all "APIs" to a separate scope
    def index
      unless request.xhr?
        return render :index
      end

      super
    end

    def collection
      AdditionalCode.q_search(params)
    end

    def preview
      if additional_code.present?
        render partial: "measures/bulks/additional_code_preview"
      else
        head :not_found
      end
    end
  end
end
