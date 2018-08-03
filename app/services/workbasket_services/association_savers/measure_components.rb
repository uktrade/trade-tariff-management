module WorkbasketServices
  module AssociationSavers
    class MeasureComponents < ::WorkbasketServices::AssociationSavers::SingleAssociation

      private

        def generate_record!
          @record = MeasureComponent.new(
            unit_ops(record_ops)
          )
          record.measure_sid = measure.measure_sid
          record.duty_expression_id = record_ops[:duty_expression_id]

          set_primary_key(record)
        end
    end
  end
end
