module Measures
  module Workbasket
    class Items

      include ::CustomLogger

      attr_accessor :workbasket,
                    :search_ops,
                    :paginator,
                    :target_records,
                    :workbasket_items

      def initialize(workbasket, search_ops)
        @workbasket = workbasket
        @search_ops = search_ops
        @paginator = ::Measures::Workbasket::Paginator.new(search_ops)
      end

      def prepare
        if workbasket.initial_items_populated.present?
          load_workbasket_items

        elsif current_page.present? && current_batch_is_not_loaded?
          fetch_target_records
          generate_initial_workbasket_items!

        end

        self
      end

      def collection
        workbasket_items.map do |item|
          item.hash_data
        end
      end

      def pagination_metadata
        paginator.metadata
      end

      private

        def fetch_target_records
          @target_records = ::Measure.bulk_edit_scope(
            :measure_sid, paginator.current_batch_ids
          )
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
          @workbasket_items = ::Workbaskets::Item.by_workbasket(workbasket)
                                                 .bulk_edit_scope(
            :record_id, paginator.current_batch_ids
          )
        end

        def final_batch_populated?
          workbasket.items.count == paginator.total_count
        end

        def current_batch_is_not_loaded?
          !workbasket.batches_loaded_pages
                     .include?(current_page)
        end

        def current_page
          paginator.current_page
        end
    end
  end
end
