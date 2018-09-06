module WorkbasketInteractions
  module BulkEditOfMeasures
    class ItemOpsNormalizer

      attr_accessor :ops,
                    :normalized_ops

      def initialize(data)
        @ops = ActiveSupport::HashWithIndifferentAccess.new(data)
        normalize!
      end

      private

        def normalize!
          @normalized_ops = {}

          normalize_duty_expressions!
          normalize_conditions!
          normalize_footnotes!
        end

        def normalize_duty_expressions!(source=nil)
          measure_components = source || ops[:measure_components]

          if measure_components.present?
            prepared_collection = []

            measure_components.map do |d_ops|
              if d_ops[:duty_expression].present? && d_ops[:duty_expression][:duty_expression_id].present?
                prepared_collection << {
                  duty_expression_id: d_ops[:duty_expression][:duty_expression_id],
                  duty_amount: d_ops[:duty_amount]
                }.merge(
                  unit_ops(d_ops)
                )
              end
            end

            if source.present?
              prepared_collection
            else
              @normalized_ops[:measure_components] = prepared_collection
            end
          end
        end

        def normalize_conditions!
          conditions = ops[:conditions]

          if conditions.present?
            prepared_collection = []

            conditions.map do |c_ops|
              if c_ops[:measure_condition_code][:condition_code].present?
                condition_ops = {
                  action_code: parsed_value(c_ops, :measure_action, :action_code),
                  condition_code: parsed_value(c_ops, :measure_condition_code, :condition_code),
                  certificate_type_code: parsed_value(c_ops, :certificate_type, :certificate_type_code),
                  certificate_code: parsed_value(c_ops, :certificate, :certificate_code),
                }

                if c_ops[:measure_condition_components].present?
                  condition_ops[:measure_condition_components] = normalize_duty_expressions!(
                    c_ops[:measure_condition_components]
                  )
                end

                prepared_collection << condition_ops
              end
            end

            @normalized_ops[:conditions] = prepared_collection
          end
        end

        def unit_ops(data)
          {
            monetary_unit_code: parsed_value(data, :monetary_unit, :monetary_unit_code),
            measurement_unit_code: parsed_value(data, :measurement_unit, :measurement_unit_code),
            measurement_unit_qualifier_code: parsed_value(data, :measurement_unit_qualifier, :measurement_unit_qualifier_code)
          }
        end
    end
  end
end
