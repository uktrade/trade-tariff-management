module WorkbasketValueObjects
  module CreateAdditionalCode
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase

      def step_transitions
        {
        }
      end

      def form_steps
        %w(
          review_and_submit
        )
      end

      def main_step_settings
        %w(
        )
      end

    end
  end
end
