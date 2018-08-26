module WorkbasketValueObjects
  module Shared
    class SystemOpsAssigner

      attr_accessor :record,
                    :ops

      def initialize(record, ops={})
        @record = record
        @ops = ops
      end

      def assign!
        assign_general_ops!
        assign_unique_sequence_number!
      end

      private

        def assign_general_ops!
          record.workbasket_id = ops[:workbasket_id]
          record.operation_date = ops[:operation_date]
          record.added_by_id = ops[:current_admin_id]
          record.status = "new_in_progress"
          record.manual_add = true
          record.operation = "C"
          record.added_at = Time.zone.now
          record.national = false
          record.try("approved_flag=", true)
          record.try("stopped_flag=", false)
        end

        def assign_bulk_edit_options!
          record.workbasket_id = ops[:workbasket_id]
          record.operation_date = ops[:operation_date]
          record.added_by_id = ops[:current_admin_id]
          record.status = "awaiting_cross_check"
          record.manual_add = true
          record.operation = "C"
          record.added_at = Time.zone.now
          record.national = false
          record.try("approved_flag=", true)
          record.try("stopped_flag=", false)

          assign_unique_sequence_number!
        end

        def assign_unique_sequence_number!
          record.workbasket_sequence_number = generate_next_sequence_number
        end

        def generate_next_sequence_number
          current_sequence_number = Rails.cache.read(cache_key).try(:to_i) || 0
          next_sequence_number = current_sequence_number + 1
          Rails.cache.write(cache_key, next_sequence_number)

          next_sequence_number
        end

        def cache_key
          "#{ops[:workbasket_id]}_sequence_number"
        end
    end
  end
end
