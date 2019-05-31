module SearchCacheHelpers
  extend ActiveSupport::Concern

  included do
    expose(:search_code) do
      code = "#{current_user.id}#{separator}#{Time.now.to_i}"

      Rails.cache.write(code, search_ops)

      code
    end

    expose(:cached_search_ops) do
      Rails.cache.read(params[:search_code]).merge(
        page: current_page,
        order_col: order_col,
        order_dir: order_dir
      )
    end

    expose(:full_search_params) do
      search_mode? ? cached_search_ops : nil
    end

    expose(:json_response) do
      {
        collection: json_collection,
        total_pages: search_results.total_pages,
        current_page: search_results.current_page,
        has_more: !search_results.last_page?
      }
    end

    expose(:pagination_metadata) do
      if search_mode?
        {
          page: search_results.current_page,
          total_count: search_results.total_count,
          per_page: search_results.limit_value
        }
      else
        {}
      end
    end

    expose(:current_page) do
      params[:page] || 1
    end

    expose(:order_col) do
      params[:order_col]
    end

    expose(:order_dir) do
      params[:order_dir] || 'asc'
    end
  end

private

  def search_mode?
    params[:search_code].present? &&
      Rails.cache.exist?(params[:search_code])
  end
end
