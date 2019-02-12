module Certificates
  class CertificatesController < ::BaseController
    skip_around_action :configure_time_machine, only: %i[search validate_search_settings]

    expose(:search_ops) do
      ops = params[:search]

      if ops.present?
        ops.send("permitted=", true)
        ops = ops.to_h
      else
        ops = {}
      end

      ops = ops.merge(
        page: params[:page]
      )

      ops[:sort_by] = params[:sort_by]
      ops[:sort_dir] = params[:sort_dir]

      ops
    end

    expose(:search_form) do
      CertificateSearchForm.new(search_ops)
    end

    expose(:searcher) do
      CertificateSearch.new(search_ops)
    end

    expose(:search_results) do
      searcher.results
    end

    def validate_search_settings
      if search_form.valid?
        render json: {}, status: :ok
      else
        render json: {
          errors: search_form.parsed_errors
        }, status: :unprocessable_entity
      end
    end

    def search
      params[:sort_by] ||= "geographical_area_id"
      params[:sort_dir] ||= "asc"
    end

    def collection
      Certificate.q_search(params)
    end
  end
end
