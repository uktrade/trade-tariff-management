module WorkbasketValueObjects
  module CreateAdditionalCode
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase
      def step_transitions
        {
        }
      end

      def form_steps
        %w(
          main
        )
      end

      def main_step_settings
        %w(
        workbasket_name
        validity_start_date
        validity_end_date
        additional_codes
        )
      end
    end
  end
end
