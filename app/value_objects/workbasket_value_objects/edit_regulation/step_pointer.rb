module WorkbasketValueObjects
  module EditRegulation
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
          base_regulation_id
          base_regulation_group
          validity_start_date
          validity_end_date
          description
        )
      end
    end
  end
end
