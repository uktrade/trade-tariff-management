module WorkbasketValueObjects
  module CreateAdditionalCode
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
        )
      end

    end
  end
end
