module CreateMeasures
  module ValidationHelpers
    class MeasureComponents < ::CreateMeasures::ValidationHelpers::AssociationBase

      attr_accessor :measure,
                    :system_ops,
                    :duty_expression,
                    :duty_expression_ops,
                    :extra_increment_value,
                    :errors

      def initialize(measure, system_ops, duty_expression_ops={})
        @measure = measure
        @system_ops = system_ops
        @duty_expression_ops = duty_expression_ops
        @extra_increment_value = duty_expression_ops[:position]

        @errors = {}
      end

      def valid?
        generate_record!
        validate!

        if @errors.blank? && !measure.new?
          persist!
        end

        @errors.blank?
      end

      def persist!
        persist_record!(duty_expression)
      end

      private

        def generate_record!
          @duty_expression = MeasureComponent.new(
            unit_ops(duty_expression_ops)
          )
          duty_expression.measure_sid = measure.measure_sid
          duty_expression.duty_expression_id = duty_expression_ops[:duty_expression_id]

          set_primary_key(duty_expression)
        end

        def validate!
          ::Measures::ConformanceErrorsParser.new(
            duty_expression, MeasureComponentValidator, {}
          ).errors
           .map do |k, v|
            @errors[k] = v
          end
        end
    end
  end
end
