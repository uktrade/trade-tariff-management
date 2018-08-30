module WorkbasketValueObjects
  module CreateRegulation
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

    end
  end
end
