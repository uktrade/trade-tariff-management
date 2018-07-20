module CreateMeasures
  module ValidationHelpers
    class SystemOpsAssigner

      attr_accessor :record,
                    :current_admin,
                    :operation_date

      def initialize(record, current_admin, operation_date)
        @record = record
        @current_admin = current_admin
        @operation_date = operation_date
      end

      def assign!
        record.manual_add = true
        record.operation = "C"
        record.operation_date = operation_date
        record.added_by_id = current_admin.id
        record.added_at = Time.zone.now
        record.national = false
        record.try("approved_flag=", true)
        record.try("stopped_flag=", false)
      end
    end
  end
end
