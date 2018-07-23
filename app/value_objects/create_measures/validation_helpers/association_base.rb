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
            record, system_ops
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

        def unit_ops(attrs)
          {
            duty_amount: attrs[:amount],
            monetary_unit_code: attrs[:monetary_unit_code],
            measurement_unit_code: attrs[:measurement_unit_code],
            measurement_unit_qualifier_code: attrs[:measurement_unit_qualifier_code]
          }
        end
    end
  end
end
