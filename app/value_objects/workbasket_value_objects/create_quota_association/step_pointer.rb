module WorkbasketValueObjects
  module CreateQuotaAssociation
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
        )
      end
    end
  end
end
