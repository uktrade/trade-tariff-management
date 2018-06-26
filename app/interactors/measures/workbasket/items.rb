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
        else

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
            target_id = record.public_send(record.primary_key)

            item = ::Workbaskets::Item.new(
              workbasket_id: workbasket.id
            )
            item.record_id = target_id
            item.record_key = record.primary_key
            item.record_type = record.class.to_s
            item.status = "in_progress"
            item.data = record.to_json.to_json

            if item.valid?
              item.save
            else
              workbasket.get_item_by_id(target_id)
            end
          end
        end

        def load_workbasket_items
          @workbasket_items = workbasket.items
                                        .order(Sequel.asc(:created_at))
        end

        def mark_workbasket_as_populated!
          workbasket.initial_items_populated = true
          workbasket.save
        end

        def final_batch_populated?
          workbasket.items.count == target_records.total_count
        end
    end
  end
end
