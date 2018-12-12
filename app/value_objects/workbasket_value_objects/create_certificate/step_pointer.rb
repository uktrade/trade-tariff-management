module WorkbasketValueObjects
  module CreateCertificate
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
          certificate_type_code
          certificate_code
          description
          operation_date
          validity_start_date
          validity_end_date
        )
      end
    end
  end
end
