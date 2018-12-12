module WorkbasketValueObjects
  module EditCertificate
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
          operation_date
          description
          description_validity_start_date
          validity_start_date
          validity_end_date
        )
      end
    end
  end
end
