module WorkbasketValueObjects
  module CreateGeographicalArea
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase

      def step_transitions
        {
          main: :review_and_submit,
        }
      end

      def form_steps
        %w(
          main
        )
      end

      def main_step_settings
        %w(
          geographical_code
          geographical_area_id
          parent_geographical_area_group_sid
          start_date
          end_date
          operation_date
        )
      end

    end
  end
end
