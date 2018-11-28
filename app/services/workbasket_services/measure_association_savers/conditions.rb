module WorkbasketServices
  module MeasureAssociationSavers
    class Conditions < ::WorkbasketServices::MeasureAssociationSavers::MultipleAssociation

      attr_accessor :measure,
                    :system_ops,
                    :condition_ops,
                    :condition,
                    :extra_increment_value,
                    :errors

      def initialize(measure, system_ops, condition_ops={})
        @measure = measure
        @system_ops = system_ops
        @condition_ops = condition_ops
        @extra_increment_value = condition_ops[:position]

        @errors = {}
      end

      def persist!
        records.map do |record|
          persist_record!(record)
        end
      end

      private

        def generate_records!
          generate_condition!
          generate_condition_components!
        end

        def validate_records!
          records.map do |record|
            validate!(record)
          end
        end

        def records
          [
            condition,
            condition.measure_condition_components
          ].flatten
        end

        def generate_condition!
          @condition = MeasureCondition.new(condition_attrs)
          condition.measure_sid = measure.measure_sid
          set_primary_key(condition)

          unless measure.exists?
            condition.measure = measure
          end
        end

        def condition_attrs
          {
            action_code: condition_ops[:action_code],
            condition_code: condition_ops[:condition_code],
            condition_duty_amount: condition_ops[:duty_amount],
            certificate_type_code: condition_ops[:certificate_type_code],
            certificate_code: condition_ops[:certificate_code],
            component_sequence_number: condition_ops[:component_sequence_number],
            original_measure_condition_code: condition_ops[:original_measure_condition_code]
          }
        end

        def generate_condition_components!
          list = condition_ops[:measure_condition_components].select do |k, v|
            v[:duty_expression_id].present?
          end.map do |k, v|
            mc_component = MeasureConditionComponent.new(
              unit_ops(v)
            )
            mc_component.measure_condition_sid = condition.measure_condition_sid
            mc_component.duty_expression_id = v[:duty_expression_id]
            mc_component.measure_condition = @condition

            mc_component
          end

          list.map do |item|
            @condition.measure_condition_components << item
          end
        end

        def validator(klass_name)
          case klass_name
          when "MeasureCondition"
            MeasureConditionValidator
          when "MeasureConditionComponent"
            MeasureConditionComponentValidator
          end
        end
    end
  end
end
