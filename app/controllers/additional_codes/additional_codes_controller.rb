module AdditionalCodes
  class AdditionalCodesController < ::BaseController

    expose(:additional_code) do
      Rails.logger.info "-" * 100
      Rails.logger.info "params[:code]: #{params[:code]}"
      Rails.logger.info "-" * 100


      AdditionalCode.by_code(params[:code])
    end

    def collection
      AdditionalCode.q_search(params)
    end

    def preview
      Rails.logger.info "-" * 100
      Rails.logger.info "additional_code: #{additional_code.inspect}"
      Rails.logger.info "-" * 100

      if additional_code.present?
        render partial: "measures/bulks/additional_code_preview"
      else
        head :not_found
      end
    end
  end
end
