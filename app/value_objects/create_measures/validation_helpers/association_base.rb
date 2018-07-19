module CreateMeasures
  module ValidationHelpers
    class AssociationBase < ::CreateMeasures::ValidationHelpers::Base

      class << self
        def errors_in_collection(measure, system_ops, collection)
          errors = {}

          collection.map do |k, item_ops|
            ops = item_ops.merge(position: k)

            record = new(measure, system_ops, ops)
            errors[k] = record.errors unless record.valid?
          end

          errors
        end
      end

      private

        def persist_record!(record)
          assigner = ::CreateMeasures::ValidationHelpers::SystemOpsAssigner.new(
            record, current_admin, operation_date
          )

          assigner.assign!
          assigner.record.save
        end

        def set_primary_key(record, extra_increment_value=nil)
          ::CreateMeasures::ValidationHelpers::PrimaryKeyGenerator.new(
            record,
            extra_increment_value
          ).assign!
        end
    end
  end
end
