module Measures
  module Workbasket
    class Items

      include ::CustomLogger

      attr_accessor :workbasket,
                    :search_ops,
                    :target_records,
                    :workbasket_items

      def initialize(workbasket, search_ops)
        @workbasket = workbasket
        @search_ops = search_ops
      end

      def prepare
        fetch_target_records

        if workbasket.initial_items_populated.present?
          load_workbasket_items

        elsif current_page.present? && current_batch_is_not_loaded?
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info " search_ops[:page]: #{search_ops[:page]}"
          Rails.logger.info ""
          Rails.logger.info " target_records: #{target_records.count}"
          Rails.logger.info ""
          Rails.logger.info " workbasket.items: #{workbasket.items.count}"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          generate_initial_workbasket_items!
        end

        self
      end

      def pagination_metadata
        Hashie::Mash.new(
          total_pages: target_records.total_pages,
          current_page: target_records.current_page,
          has_more: !target_records.last_page?,
          page: target_records.current_page,
          total_count: target_records.total_count,
          per_page: target_records.limit_value
        )
      end

      def collection
        workbasket_items.map do |item|
          item.hash_data
        end
      end

      private

        def current_batch_ids
          per_page = Kaminari.config.default_per_page
          offset = current_page.to_i.zero? ? 0 : ((current_page.to_i - 1) * per_page)
          top_limit = offset + per_page

          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info " offset: #{offset}"
          Rails.logger.info ""
          Rails.logger.info " top_limit: #{top_limit}"
          Rails.logger.info ""
          Rails.logger.info " search_ops: #{search_ops.inspect}"
          Rails.logger.info ""
          Rails.logger.info " search_ops[:measure_sids]: #{search_ops[:measure_sids].inspect}"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          search_ops[:measure_sids][offset..top_limit]
        end

        def fetch_target_records
          @target_records = ::Measure.bulk_edit_scope(current_batch_ids)
        end

        def generate_initial_workbasket_items!
          @workbasket_items = target_records.map do |record|
            ::Workbaskets::Item.create_from_target_record(
              workbasket, record
            )
          end

          workbasket.track_current_page_loaded!(current_page)
          workbasket.initial_items_populated = true if final_batch_populated?
          workbasket.save
        end

        def load_workbasket_items
          @workbasket_items = workbasket.items
                                        .order(Sequel.asc(:created_at))
        end

        def final_batch_populated?
          workbasket.items.count == target_records.total_count
        end

        def current_batch_is_not_loaded?
          !workbasket.batches_loaded_pages
                     .include?(current_page)
        end

        def current_page
          search_ops[:page].to_s
        end
    end
  end
end
