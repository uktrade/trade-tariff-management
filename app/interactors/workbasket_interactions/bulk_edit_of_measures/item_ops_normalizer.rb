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
          @normalized_ops = ops

          normalize_duty_expressions!
          normalize_conditions!
          normalize_footnotes!
          normalize_excluded_geographical_areas!

          @normalized_ops = ActiveSupport::HashWithIndifferentAccess.new(normalized_ops)
        end

        def normalize_duty_expressions!(source=nil)
          measure_components = source || ops[:measure_components]

          if measure_components.present?
            prepared_collection = {}

            measure_components.map.with_index do |d_ops, index|
              if d_ops[:duty_expression].present? && d_ops[:duty_expression][:duty_expression_id].present?
                prepared_collection[index] = {
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

          else
            @normalized_ops[:measure_components] = {}
          end
        end

        def normalize_conditions!
          conditions = ops[:measure_conditions]

          if conditions.present?
            prepared_collection = {}

            conditions.map.with_index do |c_ops, index|
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
                  ) || {}
                else
                  condition_ops[:measure_condition_components] = {}
                end

                prepared_collection[index] = condition_ops
              end
            end

            @normalized_ops[:measure_conditions] = prepared_collection
          else
            @normalized_ops[:measure_conditions] = {}
          end
        end

        def normalize_footnotes!
          footnotes = ops[:footnotes]

          if footnotes.present?
            prepared_collection = {}

            footnotes.map.with_index do |f_ops, index|
              if f_ops[:footnote_type_id].present? && f_ops[:description].present?
                prepared_collection[index] = {
                  footnote_type_id: f_ops[:footnote_type_id],
                  description: f_ops[:description]
                }
              end
            end

            @normalized_ops[:footnotes] = prepared_collection
          else
            @normalized_ops[:footnotes] = {}
          end
        end

        def normalize_excluded_geographical_areas!
          excluded_geographical_areas = ops[:excluded_geographical_areas]

          if excluded_geographical_areas.present?
            @normalized_ops[:excluded_geographical_areas] = excluded_geographical_areas.select do |area|
              area['geographical_area_id'].present?
            end.map do |area|
              area['geographical_area_id']
            end

          else
            @normalized_ops[:excluded_geographical_areas] = []
          end
        end

        def unit_ops(data)
          {
            monetary_unit_code: parsed_value(data, :monetary_unit, :monetary_unit_code),
            measurement_unit_code: parsed_value(data, :measurement_unit, :measurement_unit_code),
            measurement_unit_qualifier_code: parsed_value(data, :measurement_unit_qualifier, :measurement_unit_qualifier_code)
          }
        end

        def parsed_value(data, parent_field_name, field_name)
          parent_value = data[parent_field_name]

          if parent_value.present? && parent_value.to_s != "null"
            parent_value[field_name]
          else
            ''
          end
        end
    end
  end
end
