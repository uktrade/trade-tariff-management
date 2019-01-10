module WorkbasketValueObjects
  module CreateGeographicalArea
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase
      def has_next_step?
        false
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
          description
          parent_geographical_area_group_id
          start_date
          end_date
          operation_date
        )
      end
    end
  end
end
