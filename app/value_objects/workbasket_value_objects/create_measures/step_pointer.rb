module WorkbasketValueObjects
  module CreateMeasures
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase

      def step_transitions
        {
          main: :duties_conditions_footnotes,
          duties_conditions_footnotes: :review_and_submit
        }
      end

      def form_steps
        %w(
          main
          duties_conditions_footnotes
        )
      end

      def main_step_settings
        %w(
          regulation_id
          start_date
          end_date
          measure_type_id
          workbasket_name
          operation_date
          commodity_codes
          commodity_codes_exclusions
          additional_codes
          reduction_indicator
          geographical_area_id
          excluded_geographical_areas
        )
      end

      def duties_conditions_footnotes_step_settings
        %w(
          measure_components
          conditions
          footnotes
        )
      end

      def duties_conditions_footnotes?
        current_step == "duties_conditions_footnotes"
      end
    end
  end
end
