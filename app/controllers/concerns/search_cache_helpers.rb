module SearchCacheHelpers
  extend ActiveSupport::Concern

  included do
    expose(:search_code) do
      p ""
      p "-" * 100
      p ""
      p " controller_name: #{controller_name}"
      p ""
      p "-" * 100
      p ""

      separator = controller_name == "Measures::Measures" ? "SM" : "BE"
      code = "#{current_user.id}#{separator}#{Time.now.to_i}"
      Rails.cache.write(code, search_ops)

      code
    end
  end

  private

    def search_mode?
      params[:search_code].present? &&
      Rails.cache.exist?(params[:search_code])
    end
end
