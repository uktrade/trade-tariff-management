module AdditionalCodes
  module Workbasket
    class Paginator

      attr_accessor :search_ops,
                    :additional_code_sids

      def initialize(search_ops)
        @search_ops = search_ops
        @additional_code_sids = search_ops[:additional_code_sids]

        self
      end

      def metadata
        Hashie::Mash.new(
          page: current_page.to_i,
          current_page: current_page.to_i,
          total_count: total_count,
          total_pages: total_pages,
          has_more: has_more?,
          per_page: per_page,
          limit_value: per_page
        )
      end

      def current_batch_ids
        additional_code_sids[offset..top_limit]
      end

      def current_page
        search_ops[:page].to_s
      end

      def total_count
        additional_code_sids.size
      end

      private

        def per_page
          @per_page ||= Kaminari.config.default_per_page
        end

        def total_pages
          (total_count.to_f / per_page.to_f).ceil
        end

        def has_more?
          total_pages > current_page.to_i
        end

        def offset
          return 0 if current_page.to_i.zero?
          (current_page.to_i - 1) * per_page
        end

        def top_limit
          offset + per_page - 1
        end
    end
  end
end
