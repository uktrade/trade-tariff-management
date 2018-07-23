module CreateMeasures
  module ValidationHelpers
    class SystemOpsAssigner

      attr_accessor :record,
                    :ops

      def initialize(record, ops={})
        @record = record
        @ops = ops
      end

      def assign!
        record.workbasket_id = ops[:workbasket_id]
        record.workbasket_sequence_number = ops[:sequence_number]
        record.operation_date = ops[:operation_date]
        record.added_by_id = ops[:current_admin_id]
        record.status = "in_progress"
        record.manual_add = true
        record.operation = "C"
        record.added_at = Time.zone.now
        record.national = false
        record.try("approved_flag=", true)
        record.try("stopped_flag=", false)
      end
    end
  end
end
