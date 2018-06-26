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

        unless workbasket.initial_items_populated?
          generate_initial_workbasket_items!
          mark_workbasket_as_populated! if final_batch_populated?
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

        def fetch_target_records
          @target_records = ::Measure.bulk_edit_scope(search_ops)
        end

        def generate_initial_workbasket_items!
          @workbasket_items = target_records.map do |record|
            item = ::Workbaskets::Item.new(
              workbasket_id: workbasket.id
            )
            item.record_id = record.public_send(record.primary_key)
            item.record_key = record.primary_key
            item.record_type = record.class.to_s
            item.status = "in_progress"
            item.data = record.to_json.to_json

            item.save
          end
        end

        def mark_workbasket_as_populated!
          workbasket.initial_items_populated = true
          workbasket.save
        end

        def final_batch_populated?
          target_records.total_pages == search_ops[:page]
        end
    end
  end
end
