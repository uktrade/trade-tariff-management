module CreateMeasures
  module ValidationHelpers
    class MeasureComponents < ::CreateMeasures::ValidationHelpers::AssociationBase

      attr_accessor :measure,
                    :current_admin,
                    :operation_date,
                    :duty_expression,
                    :duty_expression_ops,
                    :extra_increment_value,
                    :errors

      def initialize(measure, system_ops, duty_expression_ops={})
        @measure = measure
        @current_admin = system_ops[:current_admin]
        @operation_date = system_ops[:operation_date]

        @duty_expression_ops = duty_expression_ops
        @extra_increment_value = duty_expression_ops[:position]

        @errors = {}
      end

      def valid?
        generate_record!
        validate!

        Rails.logger.info ""
        Rails.logger.info " measure.measure_sid: #{measure.measure_sid}"
        Rails.logger.info ""
        Rails.logger.info "@errors: #{@errors.inspect}"
        Rails.logger.info ""
        Rails.logger.info "persist: #{!measure.new?}"
        Rails.logger.info ""

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
