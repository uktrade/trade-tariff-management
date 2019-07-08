module WorkbasketValueObjects
  module EditNomenclature
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
          reason_for_changes
          description
          description_validity_start_date
        )
      end
    end
  end
end
